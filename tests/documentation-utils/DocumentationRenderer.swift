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

    /// Renders a SwiftUI view configured as a documentation image.
    static func render<Content: View>(
        _ name: String,
        size: CGSize,
        scale: CGFloat = defaultScale,
        @ViewBuilder content: () -> Content
    ) throws -> CGImage {
        let framedContent = VStack {
            content()
        }
        .frame(width: size.width, height: size.height)
        .background(.background, in: .rect)
        .border(.tertiary, width: 1)
        .environment(\.colorScheme, .light)

        let renderer = ImageRenderer(content: framedContent)
        renderer.scale = scale

        guard let cgImage = renderer.cgImage else {
            throw RendererError.renderingFailed(name)
        }
        return cgImage
    }

    /// Renders a SwiftUI view configured as a documentation image, using the default width.
    static func render<Content: View>(
        _ name: String,
        height: CGFloat,
        scale: CGFloat = defaultScale,
        @ViewBuilder content: () -> Content
    ) throws -> CGImage {
        try render(name, size: [Self.defaultWidth, height], content: content)
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
