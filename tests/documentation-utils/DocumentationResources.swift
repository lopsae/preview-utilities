//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


import CoreGraphics
import ImageIO
import Foundation
import Testing
import UniformTypeIdentifiers.UTType


/// Utility structure to store images into the documentation catalog resources.
struct DocumentationResources {

    static func store(resource: DocumentationRenderer.RenderResource) throws {
        // TODO: could check path components until `tests` is found
        // TODO: if more that X last components are checked, also throw an error
        // TODO: resources name components should have at least one element!

        // Navigate from the test bundle to the documentation resources directory.
        // This logic depends on the location of this file.
        let packageRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // documentation-utils
            .deletingLastPathComponent() // tests
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
            throw StorageError.outputDirectoryMissing(path: outputDirectory.path)
        }

        for (scheme, cgImage) in resource.images {
            let scaleInt = resource.scale.arithmeticRoundedInt
            let filename = switch scheme {
            case .light:
                // Light scheme requires NO scheme in the filename.
                // Eg: image-name@3x.png
                "\(resource.resourceName)@\(scaleInt)x.png"
            case .dark:
                // Dark scheme requires the scheme in the filename.
                // Eg: image-name~dark@3x.png
                "\(resource.resourceName)~dark@\(scaleInt)x.png"
            @unknown default:
                throw StorageError.unknownColorScheme
            }

            let folderURL = outputDirectory
                .appending(pathComponents: resource.folderPath)
            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true)

            let fileURL = folderURL
                .appending(path: filename, directoryHint: .notDirectory)

            let destination = CGImageDestinationCreateWithURL(
                fileURL as CFURL,
                UTType.png.identifier as CFString,
                1,
                nil
            )
            guard let destination else {
                throw StorageError.fileCreationFailed(path: fileURL.path)
            }
            CGImageDestinationAddImage(destination, cgImage, nil)
            guard CGImageDestinationFinalize(destination) else {
                throw StorageError.fileCreationFailed(path: fileURL.path)
            }

            // Attach image to test.
            Attachment.record(cgImage, named: filename, as: .png)
        }
    }


    static func renderAndStore(
        _ nameComponents: String...,
        illustration: () -> DocumentationIllustration
    ) throws {
        let resource = try DocumentationRenderer.render(
            nameComponents: nameComponents,
            illustration: illustration
        )
        try store(resource: resource)
    }

}


// MARK: - StorageError


extension DocumentationResources {

    enum StorageError: LocalizedError {
        case outputDirectoryMissing(path: String)
        case unknownColorScheme
        case fileCreationFailed(path: String)

        var errorDescription: String? {
            switch self {
            case .outputDirectoryMissing(let path):
                "Documentation resources directory not found: \(path)"
            case .unknownColorScheme:
                "Encountered an unknown ColorScheme"
            case .fileCreationFailed(let path):
                "Failed to write PNG to: \(path)"
            }
        }
    }

}


// MARK: - Extensions


extension URL {

    func appending<S>(pathComponents: [S]) -> URL where S : StringProtocol {
        var result = self
        for component in pathComponents {
            result = result.appending(path: component)
        }
        return result
    }

}
