//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//

import SwiftUI


extension View {

    @inlinable nonisolated
    public func alignmentGuide(
        _ alignment: VerticalAlignment,
        moveTo target: VerticalAlignment? = nil,
        offsetBy offset: CGFloat = .zero
    ) -> some View {
        self.alignmentGuide(alignment) { dimentions in
            dimentions[target ?? alignment] + offset
        }
    }


    @inlinable nonisolated
    public func alignmentGuide(
        _ alignment: HorizontalAlignment,
        moveTo target: HorizontalAlignment? = nil,
        offsetBy offset: CGFloat = .zero
    ) -> some View {
        self.alignmentGuide(alignment) { dimentions in
            dimentions[target ?? alignment] + offset
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
        moveTo target: VerticalAlignment? = nil,
        insetBy inset: CGFloat
    ) -> some View {
        let signedInset = inset * alignment.insetDirection.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedInset)
    }

    nonisolated
    func alignmentGuide(
        _ alignment: InsettableAlignment<VerticalAlignment>,
        moveTo target: VerticalAlignment? = nil,
        outsetBy outset: CGFloat
    ) -> some View {
        let signedOutset = outset * alignment.insetDirection.inverse.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedOutset)
    }

}

nonisolated
struct InsettableAlignment<AlignmentType: Sendable> {

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

    static let top:    Self = .init(baseAlignment: .top,    insetDirection: .negative)
    static let bottom: Self = .init(baseAlignment: .bottom, insetDirection: .positive)

}


// MARK: - Previews


#Preview("Vertical Inset/Outset", traits: .iPhoneProSizeForcedLayout) {
    HStack(alignment: .top){
        Rectangle()
            .fill(.red.secondary)
            .frame(width: 20, height: 120)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Manual Align", .alignment(.outerBottomLeading), .zeroPadding)
            // Negative value substracts to the top aligment pushing it farther from the view,
            // view appears pushed innwardly, thus insetting the view.
            .alignmentGuide(.top, offsetBy: -40)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Inset Align", .alignment(.outerBottomLeading), .zeroPadding)
            .alignmentGuide(.top, insetBy: 20)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Inset Align to Center", .alignment(.outerBottomLeading), .zeroPadding)
            .alignmentGuide(.top, moveTo: .center, insetBy: 20)

        Rectangle()
            .fill(.red.secondary)
            .frame(height: 5)
            .floatingCaption(
                "Original Top", .alignment(.outerBottomTrailing),
                .captionStyle(.red))

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Outset Align", .alignment(.outerBottomTrailing))
            .alignmentGuide(.top, outsetBy: 20)
    }
    .floatingCaption("Top Aligned", .alignment(.outerTopTrailing), .colorStyle(.green))
    .padding()

    HStack(alignment: .bottom){
        Rectangle()
            .fill(.red.secondary)
            .frame(width: 20, height: 120)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Manual Align", .alignment(.outerTopLeading), .zeroPadding)
            // Positive value adds to the bottom aligment pushing it farther from the view,
            // view appears pushed innwardly, thus insetting the view.
            .alignmentGuide(.bottom, offsetBy: 40)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Inset Align", .alignment(.outerTopLeading), .zeroPadding)
            .alignmentGuide(.bottom, insetBy: 20)

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Inset Align to Center", .alignment(.outerTopLeading), .zeroPadding)
            .alignmentGuide(.bottom, moveTo: .center, insetBy: 20)

        Rectangle()
            .fill(.red.secondary)
            .frame(height: 5)
            .floatingCaption(
                "Original Bottom", .alignment(.outerTopTrailing),
                .captionStyle(.red))

        Rectangle()
            .fill(.gray)
            .frame(width: 20, height: 50)
            .floatingCaption("Outset Align", .alignment(.outerTopTrailing))
            .alignmentGuide(.bottom, outsetBy: 20)
    }
    .floatingCaption("Bottom Aligned", .alignment(.outerTopTrailing), .colorStyle(.green))
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
