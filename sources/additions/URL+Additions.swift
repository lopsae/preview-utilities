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


    /// Returns a URL constructed by deleting all path components after `lastComponent`.
    ///
    /// If `lastComponent` appears multiple times in the path, the deepest occurrence is kept,
    /// minimizing the number of deleted components.
    ///
    /// When components are deleted the returned URL is a directory-style URL, terminated with
    /// a `/`.
    ///
    /// If `lastComponent` is already the last path component, the original URL is returned
    /// unchanged.
    ///
    /// - Parameters:
    ///   - lastComponent: The path component to keep as the last one of the returned URL.
    ///   - maxDeletions: The maximum number of path components allowed to be deleted.
    ///
    /// - Returns: A URL with `lastComponent` as its last path component; `nil` if
    ///   `lastComponent` is not in the path, or is only reachable by deleting more than
    ///   `maxDeletions` components.
    func deletingPathComponents(until lastComponent: String, maxDeletions: Int = .max) -> URL? {
        guard let componentIndex = pathComponents.lastIndex(of: lastComponent) else {
            return nil
        }

        let deletionCount = pathComponents.count - componentIndex - 1
        guard deletionCount <= maxDeletions else {
            return nil
        }
        return deletingPathComponents(count: deletionCount)
    }

}
