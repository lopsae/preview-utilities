//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import SwiftUI
import UniformTypeIdentifiers.UTType


/// Utility structure to store documentation illustrations into a local folder.
public struct IllustrationStorage {

    let storageDirectory: URL
    let onImageStored: (_ image: CGImage, _ filename: String) -> Void

    public init(
        filePath: String,
        droppingComponents: Int,
        appendingComponents: [String],
        folderMustExist: Bool = true,
        onImageStored: @escaping (CGImage, String) -> Void
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
        self.onImageStored = onImageStored
    }


    public func store(
        resource: IllustrationRenderer.RenderResource,
        usesFullComponentName: Bool = true
    ) throws {
        for (scheme, cgImage) in resource.images {
            let scaleInt = resource.scale.arithmeticRoundedInt
            let resourceName = usesFullComponentName
                ? resource.fullResourceName
                : resource.shortResourceName

            let filename = switch scheme {
            case .light:
                // Light scheme requires NO scheme in the filename.
                // Eg: image-name@3x.png
                "\(resourceName)@\(scaleInt)x.png"
            case .dark:
                // Dark scheme requires the scheme in the filename.
                // Eg: image-name~dark@3x.png
                "\(resourceName)~dark@\(scaleInt)x.png"
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

            onImageStored(cgImage, filename)
        }
    }


    public func renderAndStore(
        _ nameComponents: String...,
        usesFullComponentName: Bool = true,
        colorSchemes: Set<ColorScheme> = IllustrationRenderer.defaultColorSchemes,
        illustration: () -> DocumentationIllustration
    ) throws {
        try renderAndStore(
            nameComponents: nameComponents,
            usesFullComponentName: usesFullComponentName,
            colorSchemes: colorSchemes,
            illustration: illustration
        )
    }


    public func renderAndStore(
        _ nameComponents: String...,
        usesFullComponentName: Bool = true,
        colorScheme: ColorScheme,
        illustration: () -> DocumentationIllustration
    ) throws {
        try renderAndStore(
            nameComponents: nameComponents,
            usesFullComponentName: usesFullComponentName,
            colorSchemes: [colorScheme],
            illustration: illustration
        )
    }


    public func renderAndStore(
        nameComponents: [String],
        usesFullComponentName: Bool,
        colorSchemes: Set<ColorScheme>,
        illustration: () -> DocumentationIllustration
    ) throws {
        let resource = try IllustrationRenderer.render(
            nameComponents: nameComponents,
            colorSchemes: colorSchemes,
            illustration: illustration
        )
        try store(
            resource: resource,
            usesFullComponentName: usesFullComponentName
        )
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
