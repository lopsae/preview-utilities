//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension URL {

    func appending<S>(pathComponents: [S]) -> URL where S : StringProtocol {
        var result = self
        for component in pathComponents {
            result = result.appending(path: component)
        }
        return result
    }


    /// Returns a URL constructed by removing the given number of path component from the end.
    ///
    /// Deletes the given number of path components from the end by calling `URL/deletingLastPathComponent()`,
    /// see the documentation of that function for cases with special treatment.
    ///
    /// If the constructed URL reaches a point where it has an empty path that is not resolved
    /// against a base URL (e.g., `http://www.example.com`), then this function will return that URL
    /// unchanged.
    ///
    /// - Parameter count: The number of path components to delete.
    /// - Returns: The URL constructed from deleting the given number of path components.
    func deletingPathComponents(count: Int) -> URL {
        var result = self
        for _ in 0..<count {
            result = result.deletingLastPathComponent()
        }
        return result
    }

}
