//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


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
            throw StorageError.outputDirectoryMissing(outputDirectory.path)
        }


        for (scheme, cgImage) in resource.images {
            // Eg: image~dark@3x.png
            let filename = "\(resource.name)~\(scheme)@\(resource.scale)x.png"
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
