//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import ImageIO
import SwiftUI
import Testing


/// Renders SwiftUI views to PNG files for use in DocC documentation.
///
/// Rendered images are saved in the package `documentation.docc/resources` folder.
@MainActor
struct DocScreenshotRenderer {

    static let scale: CGFloat = 3
    static let defaultWidth: CGFloat = DocsScreenshotPreviewModifier.defaultWidth

    let outputDirectory: URL

    init() throws {
        // Navigate from the test bundle to the documentation resources directory.
        // Assumes tests are run from the test package root.
        let packageRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // tests/
            .deletingLastPathComponent() // package root
        outputDirectory = packageRoot
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
            throw ScreenshotError.outputDirectoryMissing(outputDirectory.path)
        }
    }

    /// Renders a SwiftUI view to a PNG file.
    ///
    /// The saved filename is `{name}@3x.png`.
    @discardableResult
    func render<Content: View>(
        _ name: String,
        size: CGSize,
        @ViewBuilder content: () -> Content
    ) throws -> URL {
        let framedContent = VStack {
            content()
        }
        .frame(width: size.width, height: size.height)
        .background(.background, in: .rect)
        .border(.tertiary, width: 1)
        .environment(\.colorScheme, .light)

        let renderer = ImageRenderer(content: framedContent)
        renderer.scale = Self.scale

        guard let cgImage = renderer.cgImage else {
            throw ScreenshotError.renderingFailed(name)
        }

        let filename = "\(name)@3x.png"
        let fileURL = outputDirectory.appendingPathComponent(filename)

        let destination = CGImageDestinationCreateWithURL(
            fileURL as CFURL,
            "public.png" as CFString,
            1,
            nil
        )
        guard let destination else {
            throw ScreenshotError.fileCreationFailed(fileURL.path)
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw ScreenshotError.fileCreationFailed(fileURL.path)
        }

        return fileURL
    }

    /// Convenience for views using only a height (with the default width).
    @discardableResult
    func render<Content: View>(
        _ name: String,
        height: CGFloat,
        @ViewBuilder content: () -> Content
    ) throws -> URL {
        try render(name, size: CGSize(width: Self.defaultWidth, height: height), content: content)
    }

    enum ScreenshotError: Error, CustomStringConvertible {
        case outputDirectoryMissing(String)
        case renderingFailed(String)
        case fileCreationFailed(String)

        var description: String {
            switch self {
            case .outputDirectoryMissing(let path):
                "Documentation resources directory not found: \(path)"
            case .renderingFailed(let name):
                "ImageRenderer failed to produce a CGImage for '\(name)'"
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
        let renderer = try DocScreenshotRenderer()
        try renderer.render("debug-overlay-default-test", height: 160) {
            Text("Sphinx of Black Quartz")
                .font(.title)
            Text("Judge my Vow")
                .font(.title)
                .debugOverlay()
        }
    }

}
