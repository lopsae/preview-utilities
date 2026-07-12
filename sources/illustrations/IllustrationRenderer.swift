//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Renders SwiftUI views to PNG files for documentation illustrations.
///
/// Rendered images are saved in the package `documentation.docc/resources` folder.
@MainActor
public struct IllustrationRenderer {

    public static let defaultWidth: CGFloat = 400
    public static let defaultScale: CGFloat = 3
    // TODO: could use ColorScheme.allCasesSet.
    public static let defaultColorSchemes: Set<ColorScheme> = [.light, .dark]


    /// Renders a SwiftUI view configured as a documentation illustration.
    ///
    /// The name components determine the folder location and name of the image. Every name
    /// component except the last is treated as the folder path where the image will be saved. The
    /// name of the image is all the name components joined with hyphens (`-`).
    public static func render(
        nameComponents: [String],
        scale: CGFloat = defaultScale,
        colorSchemes: Set<ColorScheme> = defaultColorSchemes,
        illustration: () -> DocumentationIllustration
    ) throws -> RenderResource {
        var images: [ColorScheme: CGImage] = [:]

        for scheme in colorSchemes {
            let renderer = ImageRenderer(scale: scale) {
                illustration()
                .environment(\.colorScheme, scheme)
            }

            guard let cgImage = renderer.cgImage else {
                let resourceName = RenderResource.fullResourceName(components: nameComponents)
                throw RendererError.renderingFailed(resourceName)
            }
            images[scheme] = cgImage
        }

        return RenderResource(nameComponents: nameComponents, scale: scale, images: images)
    }


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
        case renderingFailed(String)

        var errorDescription: String? {
            switch self {
            case .renderingFailed(let name):
                "DocumentationRenderer failed to produce a CGImage for '\(name)'"
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
