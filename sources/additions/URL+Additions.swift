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


    func deletingPathComponents(count: Int) -> URL {
        var result = self
        for _ in 0..<count {
            result = result.deletingLastPathComponent()
        }
        return result
    }

}
