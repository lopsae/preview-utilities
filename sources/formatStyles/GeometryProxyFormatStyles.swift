//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Namespace for format styles for `GeometryProxy`.
nonisolated
enum GeometryProxyFormatStyles {}


// MARK: - CornerRadii


extension GeometryProxyFormatStyles {

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


// MARK: - EdgeInset


extension GeometryProxyFormatStyles {

    nonisolated
    struct EdgeInsetDebugString: FormatStyle, Sendable {

        @_documentation(visibility: internal)
        func format(_ value: EdgeInsets) -> String {
            let top      = value.top
            let leading  = value.leading
            let bottom   = value.bottom
            let trailing = value.trailing

            let twoFractionals = FloatingPointFormatStyle<CGFloat>.twoFractionals
            return """
                tp:\(top, format: twoFractionals), ld:\(leading, format: twoFractionals)
                bt:\(bottom, format: twoFractionals), tr:\(trailing, format: twoFractionals)
                """
        }

    }

}


extension FormatStyle where Self == GeometryProxyFormatStyles.EdgeInsetDebugString {

    nonisolated
    static var edgeInsetDebugString: Self { .init() }

}
