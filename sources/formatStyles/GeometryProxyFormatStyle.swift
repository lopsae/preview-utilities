//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
enum GeometryProxyFormatStyles {

    nonisolated
    struct ConcentricCornerRadiiDebugString: FormatStyle, Sendable {

        // TODO: add parameter to add newline after some data?

        init() { }

        @_documentation(visibility: internal)
        func format(_ value: RectangleCornerRadii) -> String {
            let tl = value.topLeading
            let tt = value.topTrailing
            let bl = value.bottomLeading
            let bt = value.bottomTrailing

            let twoFractionals = FloatingPointFormatStyle<CGFloat>.twoFractionals
            let radiiString = """
                tl: \(tl, format: twoFractionals), tt: \(tt, format: twoFractionals),
                bl: \(bl, format: twoFractionals), bt: \(bt, format: twoFractionals)
                """

            return radiiString
        }

    }

}


extension FormatStyle where Self == GeometryProxyFormatStyles.ConcentricCornerRadiiDebugString {

    nonisolated
    static var concentricRadiiDebugString: Self { .init() }

}
