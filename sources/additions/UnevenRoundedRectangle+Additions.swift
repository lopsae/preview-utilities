//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension UnevenRoundedRectangle {

    nonisolated
    static let zero: Self = .init(cornerRadii: .zero)


    @inlinable nonisolated
    public init(
        tl: CGFloat,
        bl: CGFloat,
        bt: CGFloat,
        tt: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     tl,
            bottomLeadingRadius:  bl,
            bottomTrailingRadius: bt,
            topTrailingRadius:    tt,
            style: style
        )
    }


    @inlinable nonisolated
    public init(
        leading:  CGFloat,
        trailing: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     leading,
            bottomLeadingRadius:  leading,
            bottomTrailingRadius: trailing,
            topTrailingRadius:    trailing,
            style: style
        )
    }


    @inlinable nonisolated
    public init(
        top:    CGFloat,
        bottom: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     top,
            bottomLeadingRadius:  bottom,
            bottomTrailingRadius: bottom,
            topTrailingRadius:    top,
            style: style
        )
    }


    // FIXME: Consider if keeping.
    // Alternate corners.
    @inlinable nonisolated
    public init(
        tlbt: CGFloat,
        bltt: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     tlbt,
            bottomLeadingRadius:  bltt,
            bottomTrailingRadius: tlbt,
            topTrailingRadius:    bltt,
            style: style
        )
    }


    // FIXME: Consider if keeping.
    // Alternate corners
    //
    // For forward leaning diagonal corners (tt & bl), and backward leaning (tl & bt).
    @inlinable nonisolated
    public init(
        forwards:  CGFloat,
        backwards: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     backwards,
            bottomLeadingRadius:  forwards,
            bottomTrailingRadius: backwards,
            topTrailingRadius:    forwards,
            style: style
        )
    }


    // Alternate corners
    //
    // For even diagonal corners (tl & bt), and odd (bl & tt).
    @inlinable nonisolated
    public init(
        even: CGFloat,
        odd:  CGFloat,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius:     even,
            bottomLeadingRadius:  odd,
            bottomTrailingRadius: even,
            topTrailingRadius:    odd,
            style: style
        )
    }

}
