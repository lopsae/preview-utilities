//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

#if canImport(UIKit)
import UIKit
#endif


/// Renders SwiftUI views to PNG files for documentation illustrations.
///
/// The rendered produces ``RenderResource`` instances that contain the rendered images and
/// naming information. Use ``IllustrationStorage`` to store this resources into files using
/// the Docc naming format for images.
@MainActor
public struct IllustrationRenderer {

    public static let defaultWidth: CGFloat = 400
    public static let defaultScale: CGFloat = 3
    public static let defaultColorSchemes: Set<ColorScheme> = ColorScheme.allCasesSet


    /// The strategy used to rasterize an illustration.
    public enum Strategy {

        /// Rasterizes with `ImageRenderer`.
        ///
        /// Fast and headless software renderer. However, it cannot capture effects that depend on
        /// the render server compositing the backdrop, such as materials, blurs, and Liquid Glass
        /// controls.
        ///
        /// Unsupported views are rendered as blank or placeholders.
        case imageRenderer

        /// Rasterizes by hosting the illustration in an on-screen `UIWindow` and capturing its
        /// composited view hierarchy.
        ///
        /// Captures render-server effects like materials, blurs, and Liquid Glass. Requires a host
        /// application or scene environment, for example running inside a test on the simulator.
        ///
        /// Available only on platforms with UIKit; elsewhere it falls back to ``imageRenderer``.
        case windowHierarchy
    }


    /// Renders a SwiftUI view configured as a documentation illustration.
    /// 
    /// The name components determine the folder location and name of the image. Every name
    /// component except the last is treated as the folder path where the image will be saved. The
    /// name of the image is all the name components joined with hyphens (`-`).
    /// 
    /// - Returns: A render resource contained the rendered images and can be stored using a
    ///   ``IllustrationStorage``.
    public static func render(
        nameComponents: [String],
        scale: CGFloat = defaultScale,
        colorSchemes: Set<ColorScheme> = defaultColorSchemes,
        strategy: Strategy = .imageRenderer,
        illustration: () -> DocumentationIllustration
    ) throws -> RenderResource {
        var images: [ColorScheme: CGImage] = [:]

        for scheme in colorSchemes {
            let cgImage: CGImage? = switch strategy {
            case .imageRenderer:
                try imageRendererCGImage(
                    nameComponents: nameComponents, scheme: scheme,
                    scale: scale, illustration: illustration)
            case .windowHierarchy:
                try windowHierarchyCGImage(
                    nameComponents: nameComponents, scheme: scheme,
                    scale: scale, illustration: illustration)
            }

            images[scheme] = cgImage
        }

        return RenderResource(nameComponents: nameComponents, scale: scale, images: images)
    }


    /// Rasterizes the illustration with `ImageRenderer`.
    private static func imageRendererCGImage(
        nameComponents: [String],
        scheme: ColorScheme,
        scale: CGFloat,
        illustration: () -> DocumentationIllustration
    ) throws -> CGImage {
        let renderer = ImageRenderer(scale: scale) {
            illustration()
            .environment(\.colorScheme, scheme)
        }

        guard let image = renderer.cgImage else {
            let resourceName = RenderResource.fullResourceName(components: nameComponents)
            throw RendererError.imageRendererRenderFailed(resourceName: resourceName)
        }

        return image
    }


    #if canImport(UIKit)
    /// Rasterizes the illustration by hosting it in an on-screen window and capturing its
    /// composited view hierarchy, so render-server effects like Liquid Glass are included.
    private static func windowHierarchyCGImage(
        nameComponents: [String],
        scheme: ColorScheme,
        scale: CGFloat,
        illustration: () -> DocumentationIllustration
    ) throws -> CGImage {
        let illustration = illustration()
        let size = illustration.sizing.size
        let style = scheme.uiUserInterfaceStyle

        let host = UIHostingController(rootView: illustration.environment(\.colorScheme, scheme))
        host.overrideUserInterfaceStyle = style
        host.safeAreaRegions = []
        host.view.frame = CGRect(origin: .zero, size: size)
        host.view.backgroundColor = .clear

        // A key, visible window is what makes the render server composite backdrop effects. The
        // window must belong to an active foreground scene, otherwise the render server refuses to
        // snapshot it (see the capture failure below). This requires the tests to be hosted by an
        // application; a host-less test bundle has no such scene.
        guard let windowScene = activeWindowScene else {
            throw RendererError.noActiveWindowScene
        }

        let window = UIWindow(windowScene: windowScene)
        window.frame = .init(origin: .zero, size: size)
        window.rootViewController = host
        window.overrideUserInterfaceStyle = style
        window.makeKeyAndVisible()
        host.view.layoutIfNeeded()

        // Allow view to be composited before capturing with `drawHierarchy`.
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))

        var didCapture = false
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false
        let uiRenderer = UIGraphicsImageRenderer(bounds: host.view.bounds, format: format)
        let uiImage = uiRenderer.image { _ in
            didCapture = host.view.drawHierarchy(in: host.view.bounds, afterScreenUpdates: true)
        }

        // Tear down the temporary window.
        window.isHidden = true
        window.rootViewController = nil

        guard didCapture, let cgImage = uiImage.cgImage else {
            let resourceName = RenderResource.fullResourceName(components: nameComponents)
            throw RendererError.windowHierarchyRenderFailed(resourceName: resourceName)
        }

        return cgImage
    }


    /// The active foreground window scene, if any, used to host the capture window.
    private static var activeWindowScene: UIWindowScene? {
        let scenes = UIApplication.shared.connectedScenes
        let foreground = scenes.first { $0.activationState == .foregroundActive }
        return (foreground ?? scenes.first) as? UIWindowScene
    }
    #else
    /// Fallback for platforms without UIKit: the window hierarchy path is unavailable, so this
    /// rasterizes with `ImageRenderer` (which cannot capture render-server effects).
    private static func windowHierarchyCGImage(
        nameComponents: [String],
        scheme: ColorScheme,
        scale: CGFloat,
        illustration: () -> DocumentationIllustration
    ) throws -> CGImage {
        throw RendererError.windowHierarchyStrategyUnavailable
    }
    #endif


    /// Container of the rendered documentation illustrations.
    ///
    /// Contains the information needed to store a rendered documentation illustration: the name
    /// components, image scale, and the images for each rendered color scheme.
    public struct RenderResource {

        /// Components of the resource name.
        ///
        /// Determines the folder location and name of the image. Every component except the last is
        /// used as the folder path where the image will be saved in the documentation catalog
        /// resources folder. The name of the resource is all the name components joined with
        /// hyphens (`-`).
        let nameComponents: [String]
        let scale: CGFloat
        let images: [ColorScheme: CGImage]


        init(
            nameComponents: [String],
            scale: CGFloat,
            images: [ColorScheme : CGImage],
        ) {
            precondition(!nameComponents.isEmpty, "nameComponents must contain at least one element")
            self.nameComponents = nameComponents
            self.scale = scale
            self.images = images
        }

        /// Returns the folder path where to store the illustration.
        ///
        /// The folder path components are all the ``nameComponents`` except for the last one.
        var folderPathComponents: [String] {
            // TODO: name components should have at least one element! otherwise this will crash.
            Array(nameComponents.prefix(nameComponents.count - 1))
        }

        /// Returns the resource name, all the given components joined by hyphens (`-`).
        static func fullResourceName(components: [String]) -> String {
            components.joined(separator: "-")
        }

        /// Returns the full resource name: all the `nameComponents` joined by hyphens (`-`).
        var fullResourceName: String {
            Self.fullResourceName(components: nameComponents)
        }

        /// Returns the short resource name: the last element of `nameComponents`.
        var shortResourceName: String {
            guard let lastComponent = nameComponents.last else {
                preconditionFailure("nameComponents must contain at least one element")
            }
            return lastComponent
        }
    }


    enum RendererError: LocalizedError {
        case imageRendererRenderFailed(resourceName: String)
        case windowHierarchyRenderFailed(resourceName: String)
        case noActiveWindowScene
        case windowHierarchyStrategyUnavailable

        var errorDescription: String? {
            switch self {
            case .imageRendererRenderFailed(let resourceName):
                "ImageRenderer strategy failed to produce a CGImage for '\(resourceName)'"
            case .windowHierarchyRenderFailed(let resourceName):
                "WindowHierarchy strategy failed to produce a CGImage for '\(resourceName)'"
            case .noActiveWindowScene:
                "WindowHierarchy strategy found no active window scene to render"
            case .windowHierarchyStrategyUnavailable:
                "WindowHierarchy strategy is not available on this platform"
            }
        }
    }

}


extension ImageRenderer {

    /// Convenience initializer that renders the given content at the specified scale.
    convenience init(scale: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(content: content())
        self.scale = scale
    }

}


#if canImport(UIKit)
extension ColorScheme {

    /// The `UIUserInterfaceStyle` matching this color scheme.
    var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .dark:       .dark
        case .light:      .light
        @unknown default: .light
        }
    }

}
#endif
