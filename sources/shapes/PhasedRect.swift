//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Rectangle shape with a phased start.
///
/// When a dashed stroke style is used in a regular rectangle, the top-leading corner always
/// shows a gap in the dash pattern, since that is the point the path starts and ends.
///
/// This shape phases the start point in the _y_ component, allowing the dashed pattern to draw
/// property in all corners.
///
/// A positive `phase` value offsets the start point of the rectangle shape along the leading side.
/// The rectangle start point can be phased as much as the rectangle height, larger values result
/// in the rectangle shape starting at the bottom-leading corner.
///
/// Negative `phase` values are ignored, resulting in the rectangle shape starting at the
/// top-leading corner.
nonisolated
struct PhasedRect: InsettableShape {
    let phase: CGFloat
    let inset: CGFloat

    init(phase: CGFloat, inset: CGFloat = .zero) {
        self.phase = phase
        self.inset = inset
    }

    func inset(by amount: CGFloat) -> Self {
        .init(phase: phase, inset: inset + amount)
    }

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.inset(by: inset)
        var path = Path()

        // FIXME: Negative phase can happen with negative insets.
        let yOffset = (insetRect.minY + phase).clamped(to: insetRect.minY...insetRect.maxY)

        path.move(to: insetRect.topLeadingPoint.adding(y: yOffset))
        path.addLine(to: insetRect.topLeadingPoint)
        path.addLine(to: insetRect.topTrailingPoint)
        path.addLine(to: insetRect.bottomTrailingPoint)
        path.addLine(to: insetRect.bottomLeadingPoint)
        path.closeSubpath()
        return path
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter) {
    @Previewable @State var phase: CGFloat = 10
    @Previewable @State var inset: CGFloat = 4
    @Previewable @State var length: CGFloat = 120
    @Previewable @State var lineWidth: CGFloat = 4

    Slider.captioned(
        "Phase", value: $phase, in: -20...50,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Inset", value: $inset, in: -20...30,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Line Width", value: $lineWidth, in: -20...30,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Length", value: $length, in: 0...200,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    DashedDivider()

    VisibleSpacer()

    PhasedRect(phase: phase, inset: inset)
    .stroke(.red, style: .dashed(width: lineWidth))
    .frame(squareOf: length)
    .border(.red.tertiary, width: 1)

    VisibleSpacer()
}
