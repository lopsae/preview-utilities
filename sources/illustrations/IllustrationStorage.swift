//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import SwiftUI
import UniformTypeIdentifiers.UTType
import Testing


/// Utility structure to store documentation illustrations into a local folder.
public struct IllustrationStorage {

    let storageDirectory: URL

    public init(
        filePath: String,
        droppingComponents: Int,
        appendingComponents: [String],
        folderMustExist: Bool = true
    ) throws {
        let baseDirectory = URL(fileURLWithPath: filePath)
            .deletingPathComponents(count: droppingComponents)
        let outputDirectory = baseDirectory.appending(pathComponents: appendingComponents)

        if folderMustExist {
            // Verify the output directory exists.
            var isDirectory: ObjCBool = false
            let exists = FileManager.default.fileExists(
                atPath: outputDirectory.path,
                isDirectory: &isDirectory
            )
            guard exists, isDirectory.boolValue else {
                throw StorageError.storageDirectoryMissing(path: outputDirectory.path)
            }
        }

        self.storageDirectory = outputDirectory
    }


    public func store(resource: IllustrationRenderer.RenderResource) throws {
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

            let folderURL = storageDirectory
                .appending(pathComponents: resource.folderPathComponents)
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


    public func renderAndStore(
        _ nameComponents: String...,
        colorSchemes: Set<ColorScheme> = IllustrationRenderer.defaultColorSchemes,
        illustration: () -> DocumentationIllustration
    ) throws {
        let resource = try IllustrationRenderer.render(
            nameComponents: nameComponents,
            colorSchemes: colorSchemes,
            illustration: illustration
        )
        try store(resource: resource)
    }


    public func renderAndStore(
        _ nameComponents: String...,
        colorScheme: ColorScheme,
        illustration: () -> DocumentationIllustration
    ) throws {
        let resource = try IllustrationRenderer.render(
            nameComponents: nameComponents,
            colorSchemes: [colorScheme],
            illustration: illustration
        )
        try store(resource: resource)
    }

}


// MARK: - StorageError


extension IllustrationStorage {

    enum StorageError: LocalizedError {
        case storageDirectoryMissing(path: String)
        case unknownColorScheme
        case fileCreationFailed(path: String)

        var errorDescription: String? {
            switch self {
            case .storageDirectoryMissing(let path):
                "Directory for illustration storage must already exist: \(path)"
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


    func deletingPathComponents(count: Int) -> URL {
        var result = self
        for _ in 0..<count {
            result = result.deletingLastPathComponent()
        }
        return result
    }

}
