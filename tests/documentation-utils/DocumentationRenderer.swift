//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import PreviewUtilities


/// Renders SwiftUI views to PNG files for use in DocC documentation.
///
/// Rendered images are saved in the package `documentation.docc/resources` folder.
@MainActor
struct DocumentationRenderer {

    static let defaultWidth: CGFloat = 400
    static let defaultScale: CGFloat = 3
    static let defaultColorSchemes: Set<ColorScheme> = [.light, .dark]


    /// Renders a SwiftUI view configured as a documentation image.
    ///
    /// The name components determine the folder location and name of the image. Every name
    /// component except the last is treated as the folder path where the image will be saved. The
    /// name of the image is all the name components joined with hyphens (`-`).
    static func render(
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
                let resourceName = RenderResource.resourceName(components: nameComponents)
                throw RendererError.renderingFailed(resourceName)
            }
            images[scheme] = cgImage
        }

        return RenderResource(nameComponents: nameComponents, scale: scale, images: images)
    }


    /// Container of a rendered documentation resource. May contain different images for each color
    /// scheme.
    struct RenderResource {

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

        var folderPath: [String] {
            Array(nameComponents.prefix(nameComponents.count - 1))
        }

        static func resourceName(components: [String]) -> String {
            components.joined(separator: "-")
        }

        var resourceName: String {
            Self.resourceName(components: nameComponents)
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

    convenience init(scale: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(content: content())
        self.scale = scale
    }

}
