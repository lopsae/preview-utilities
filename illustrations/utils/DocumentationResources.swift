//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import Testing


/// Utility structure to access the documentation catalog resources.
struct DocumentationResources {

    /// Returns an illustration storage configured to a subfolder of the resources folder of the
    /// documentation catalog.
    static func storage(at components: String...) throws -> IllustrationStorage {
        try .init(
            filePath: #filePath,
            droppingComponents: 3, // filename, utils, illustrations
            appendingComponents: ["sources", "documentation.docc", "resources"] + components
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }
    }


    /// Returns an illustration storage configured to the resources folder of the documentation
    /// catalog.
    static var storage: IllustrationStorage {
        get throws {
            try storage()
        }
    }

}
