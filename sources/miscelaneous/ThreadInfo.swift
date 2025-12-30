//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import RegexBuilder


nonisolated struct ThreadInfo {

    static func currentDisplayNumber() -> String {
        let threadDescription = Thread.current.description
        let threadNumber = threadDescription.firstMatch {
            Regex {
                One("number = ")
                Capture {
                    OneOrMore(.digit)
                }
            }
        }?.1

        return threadNumber?.description ?? "nil"
    }

    static func currentDisplayName() -> String {
        let name = Thread.isMainThread ? "Main" : "Background"
        let number = currentDisplayNumber()
        return "\(name) \(number)"
    }

}
