//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension DefaultStringInterpolation {

    mutating func appendInterpolation(nilDefault string: String?) {
        appendInterpolation(string, default: "nil")
    }

    mutating func appendInterpolation(emptyDefault string: String?) {
        appendInterpolation(string, default: "")
    }

}
