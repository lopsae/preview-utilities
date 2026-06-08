//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


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
            )
        }
    }

}
