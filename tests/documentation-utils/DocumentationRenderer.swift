//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Renders SwiftUI views to PNG files for use in DocC documentation.
///
/// Rendered images are saved in the package `documentation.docc/resources` folder.
@MainActor
struct DocumentationRenderer {

    static let defaultWidth: CGFloat = 400
    static let defaultScale: CGFloat = 3
    static let defaultColorSchemes: Set<ColorScheme> = [.light, .dark]

    /// Renders a SwiftUI view configured as a documentation image.
    static func render<Content: View>(
        _ name: String,
        size: CGSize,
        scale: CGFloat = defaultScale,
        colorSchemes: Set<ColorScheme> = defaultColorSchemes,
        @ViewBuilder content: () -> Content
    ) throws -> RenderResource {
        var images: [ColorScheme: CGImage] = [:]

        for scheme in colorSchemes {
            let renderer = ImageRenderer(scale: scale) {
                VStack {
                    content()
                }
                .frame(width: size.width, height: size.height)
                .background(.background, in: .rect)
                .border(.tertiary, width: 1)
                .environment(\.colorScheme, scheme)
            }

            guard let cgImage = renderer.cgImage else {
                throw RendererError.renderingFailed(name)
            }
            images[scheme] = cgImage
        }

        return RenderResource(name: name, scale: scale, images: images)
    }

    /// Renders a SwiftUI view configured as a documentation image, using the default width.
    static func render<Content: View>(
        _ name: String,
        height: CGFloat,
        scale: CGFloat = defaultScale,
        colorSchemes: Set<ColorScheme> = defaultColorSchemes,
        @ViewBuilder content: () -> Content
    ) throws -> RenderResource {
        try render(
            name, size: [Self.defaultWidth, height],
            scale: scale, colorSchemes: colorSchemes,
            content: content
        )
    }


    /// Container of a rendered documentation resource. May contain different images for each color
    /// scheme.
    struct RenderResource {
        let name: String
        let scale: CGFloat
        let images: [ColorScheme: CGImage]
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

    convenience init(scale: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(content: content())
        self.scale = scale
    }

}
