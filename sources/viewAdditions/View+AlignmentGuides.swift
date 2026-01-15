//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//

import SwiftUI


extension View {

    @inlinable nonisolated
    public func alignmentGuide(_ alignment: VerticalAlignment, offsetBy offset: CGFloat) -> some View {
        self.alignmentGuide(alignment) { dimentions in
            dimentions[alignment] + offset
        }
    }


    @inlinable nonisolated
    public func alignmentGuide(_ alignment: HorizontalAlignment, offsetBy offset: CGFloat) -> some View {
        self.alignmentGuide(alignment) { dimentions in
            dimentions[alignment] + offset
        }
    }

    nonisolated
    func alignmentGuide(
        _ alignment: InsettableAlignment<VerticalAlignment>,
        insetBy inset: CGFloat
    ) -> some View {
        let signedInset = inset * alignment.insetDirection.multiplier
        return self.alignmentGuide(alignment.baseAlignment, offsetBy: signedInset)
    }

    nonisolated
    func alignmentGuide(
        _ alignment: InsettableAlignment<VerticalAlignment>,
        outsetBy outset: CGFloat
    ) -> some View {
        let signedOutset = outset * alignment.insetDirection.inverse.multiplier
        return self.alignmentGuide(alignment.baseAlignment, offsetBy: signedOutset)
    }

}

nonisolated
struct InsettableAlignment<AlignmentType: DirectionalAlignment> {

    let baseAlignment: AlignmentType
    let insetDirection: InsetDirection

    enum InsetDirection {
        case positive, negative

        var multiplier: CGFloat {
            switch self {
            case .positive: +1
            case .negative: -1
            }
        }

        var inverse: Self {
            switch self {
            case .positive: .negative
            case .negative: .positive
            }
        }
    }

}

extension InsettableAlignment where AlignmentType == VerticalAlignment {

    static var top:    Self = .init(baseAlignment: .top,    insetDirection: .negative)
    static var bottom: Self = .init(baseAlignment: .bottom, insetDirection: .positive)

}

// TODO: is protocol this actually needed?
protocol DirectionalAlignment: Sendable {

    var key: AlignmentKey { get }


}

extension VerticalAlignment: DirectionalAlignment {}

extension HorizontalAlignment: DirectionalAlignment {}


#Preview("AlignmentGuides") {
    HStack(alignment: .bottom){
        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 100)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Manual Align", .alignment(.outerTopLeading), .padding(0))
        // Positive value adds to the bottom aligment pushing it farther,
        // view appears pushed innwardly, thus insetting the view.
            .alignmentGuide(.bottom, offsetBy: 40)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Inset Align", .alignment(.outerTopLeading), .padding(0))
        // Positive value adds to the bottom aligment pushing it farther,
        // view appears pushed innwardly, thus insetting the view.
            .alignmentGuide(.bottom, insetBy: 20)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Outset Align", .alignment(.outerTopLeading), .padding(0))
        // Positive value adds to the bottom aligment pushing it farther,
        // view appears pushed innwardly, thus insetting the view.
            .alignmentGuide(.bottom, outsetBy: 20)

        Rectangle()
            .fill(.red.secondary)
            .frame(height: 5)
            .floatingCaption("Original Bottom", .alignment(.outerTopTrailing))
    }
    .border(.green.secondary)
    // TODO: floatingCaption could have a trait for caption, border (or both) color.
    .floatingCaption("Bottom Aligned", .alignment(.outerTopTrailing))
    .padding()

    ZStack(alignment: .bottom) {
        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)

        Rectangle()
            .fill(.red.secondary)
            .frame(height: 5)
            .floatingCaption("Bottom", .alignment(.outerTopTrailing))
    } // ZStack
    .border(.purple.secondary)
    .alignmentGuide(.bottom, outsetBy: 20)
    .frame(size: .square(of: 100), alignment: .bottom)
    .floatingCaption("Frame Bottom Aligned", .alignment(.outerTopTrailing))
    .border(.teal)
}
