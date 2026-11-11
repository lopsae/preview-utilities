//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// A filled  rectangle framed to a given size.
public struct FilledRectangle<Style: ShapeStyle> : View {

    let fill: Style
    private let size: FrameSize


    /// Creates a filled rectangle constrained to width, height, or both.
    ///
    /// - Parameters:
    ///   - fill: The fill style of the rectangle.
    ///   - width: The width of the rectangle, or `nil` to expand width-wise; defaults to `nil`.
    ///   - height: The height of the rectangle, or `nil` to expand height-wise; defaults to `nil`.
    public init(_ fill: Style, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.fill = fill
        self.size = .init(width: width, height: height)
    }


    
    /// Creates a filled rectangle constrained to the given size.
    ///
    /// - Parameters:
    ///   - fill: The fill style of the rectangle.
    ///   - size: The size of the rectangle.
    public init(_ fill: Style, size: CGSize) {
        self.fill = fill
        self.size = .init(width: size.width, height: size.height)
    }


    @_documentation(visibility: internal)
    public var body: some View {
        Rectangle()
        .fill(fill)
        .frame(size: size)
    }

}


/// Experimental structure to represent the possible frame constraints.
private struct FrameSize {

    enum Length {
        case fixed(CGFloat)
        case unconstrained

        init(_ value: CGFloat? = nil) {
            self = value.map { .fixed($0) } ?? .unconstrained
        }
    }

    let width: Length
    let height: Length

    init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = .init(width)
        self.height = .init(height)
    }
}


private extension View {

    func frame(size: FrameSize) -> some View {
        let width: CGFloat? = switch size.width {
        case .fixed(let length): length
        case .unconstrained: nil
        }
        let height: CGFloat? = switch size.height {
        case .fixed(let length): length
        case .unconstrained: nil
        }
        return self.frame(width: width, height: height)
    }

}



// MARK: - Previews


#Preview(traits: .fixedHeader) {
    FilledRectangle(.cyan.gradient, width: 20)
    .frame(height: 100)
    .floatingCaption(alignment: .outerTrailing, .size)

    FilledRectangle(.cyan.gradient, height: 20)
    .frame(width: 100)
    .floatingCaption(alignment: .outerTrailing, .size)

    FilledRectangle(.cyan.gradient, size: .square(of: 50))
    .floatingCaption(alignment: .outerTrailing, .size)
}
