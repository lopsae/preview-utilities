//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension DefaultStringInterpolation {

    mutating func appendInterpolation<T>(nilDefault value: T?) {
        appendInterpolation(value, default: "nil")
    }

    mutating func appendInterpolation<T>(emptyDefault value: T?) {
        appendInterpolation(value, default: String())
    }

}
