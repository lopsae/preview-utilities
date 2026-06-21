//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import Testing


/// Utility structure to access the documentation catalog resources.
struct DocumentationResources {

    /// Returns an illustration storage configured to the resources folder of the documentation
    /// catalog.
    static var storage: IllustrationStorage {
        get throws {
            try .init(
                filePath: #filePath,
                droppingComponents: 3, // filename, utils, illustrations
                appendingComponents: ["sources", "documentation.docc", "resources"]
            ) {
                // onImageStored
                cgImage, filename in
                Attachment.record(cgImage, named: filename, as: .png)
            }
        }
    }

}
