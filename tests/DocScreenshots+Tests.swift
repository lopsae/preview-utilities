//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import ImageIO
import SwiftUI
import Testing
import UniformTypeIdentifiers.UTType


/// Renders SwiftUI views to PNG files for use in DocC documentation.
///
/// Rendered images are saved in the package `documentation.docc/resources` folder.
@MainActor
struct DocumentationRenderer {

    static let defaultWidth: CGFloat = DocsScreenshotPreviewModifier.defaultWidth
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


struct DocumentationResources {

    static func store(name: String, cgImage: CGImage) throws {
        // Navigate from the test bundle to the documentation resources directory.
        // Assumes this file is located at the root of the tests folder.
        let packageRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // tests/
            .deletingLastPathComponent() // package root
        let outputDirectory = packageRoot
            .appendingPathComponent("sources")
            .appendingPathComponent("documentation.docc")
            .appendingPathComponent("resources")

        // Verify the output directory exists.
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(
            atPath: outputDirectory.path,
            isDirectory: &isDirectory
        )
        guard exists, isDirectory.boolValue else {
            throw StorageError.outputDirectoryMissing(outputDirectory.path)
        }

        let filename = "\(name)@3x.png"
        let fileURL = outputDirectory.appendingPathComponent(filename)

        let destination = CGImageDestinationCreateWithURL(
            fileURL as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        )
        guard let destination else {
            throw StorageError.fileCreationFailed(fileURL.path)
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw StorageError.fileCreationFailed(fileURL.path)
        }

        // Attach image to test.
        Attachment.record(cgImage, named: filename, as: .png)
    }


    enum StorageError: LocalizedError {
        case outputDirectoryMissing(String)
        case fileCreationFailed(String)

        var errorDescription: String? {
            switch self {
            case .outputDirectoryMissing(let path):
                "Documentation resources directory not found: \(path)"
            case .fileCreationFailed(let path):
                "Failed to write PNG to: \(path)"
            }
        }
    }

}


// MARK: - Screenshot Tests


/// Each test uses a `DocScreenshotRenderer` to produce an image that is saved to the package
/// documentation catalog.
struct DocScreenshotTests {

    @Test func debugOverlayDefault() throws {
        let render = try DocumentationRenderer.render("debug-overlay-default-test", height: 160) {
            Text("Sphinx of Black Quartz")
                .font(.title)
            Text("Judge my Vow")
                .font(.title)
                .debugOverlay()
        }
        try DocumentationResources.store(name: "debug-overlay-default-test", cgImage: render)
    }

}
