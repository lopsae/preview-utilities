//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


/// Utility structure to access the documentation catalog resources.
struct DocumentationResources {

    /// Returns an illustration storage configured to the resources folder of the package
    /// documentation catalog.
    static var storage: IllustrationStorage {
        get throws {
            try .init(
                filePath: #filePath,
                droppingComponents: 3, // filename, utils, renders
                appendingComponents: ["sources", "documentation.docc", "resources"]
            )
        }
    }

}
