//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

/// A toggle style that displays a leading round button along a label.
///
/// This style is composable with `LabelStyle`, stack it with other label styles to compose its
/// effects.
struct RoundCheckmarkToggleStyle: ToggleStyle {

    // FIXME: When animations are off, pressedScale may need to be adjusted to prevent the pop.
    private let playback: AnimationPlayback

    init(playback: AnimationPlayback = .normal) {
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let symbolToggle = SymbolToggle(
            toggle: configuration.isOn,
            firstStyle: .white,
            secondStyle: .secondary,
            animations: playback
        )

        let capsuleStyle: AnyShapeStyle = .if(configuration.isOn, then: .tint, else: .gray.secondary)
        let buttonStyle = PopCapsuleIconButtonStyle(
            style: capsuleStyle,
            animations: playback
        )

        Button(
            action: { configuration.isOn.toggle() },
            title: configuration.label,
            icon: symbolToggle
        )
        .buttonStyle(buttonStyle)
    }
}


// MARK: - ToggleStyle Extension


extension ToggleStyle where Self == RoundCheckmarkToggleStyle {

    static var roundCheckmark: Self { .init() }

}


// MARK: - OnlyToggle

// FIXME: Move to its own file.


/// A toggle style that displays only the switch.
///
/// This style uses fixed sizes to force the switch in place, different devices or operating systems
/// may show incorrectly framed switches.
struct OnlySwitchToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Toggle(isOn: configuration.$isOn) {
            EmptyView()
        }
        // TODO: Should the label be added as accessibility element?
        .toggleStyle(.switch)
        .frame(width: 59, alignment: .trailing)
    }
}


extension ToggleStyle where Self == OnlySwitchToggleStyle {
    static var onlySwitch: Self { .init() }
}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggleValues: [
        (title: LocalizedStringKey, isOn: Bool, playback: AnimationPlayback)
    ] = [
        ("First Toggle",  true,  .normal),
        ("Second Toggle", false, .normal),
        ("Slow Toggle",   true,  .slow),
        ("No Animations", true,  .disabled)
    ]

    VStack($toggleValues.indexed(), id: \.index, alignment: .leading) { index, $values in
        Toggle(values.title, isOn: $values.isOn)
        .toggleStyle(RoundCheckmarkToggleStyle(playback: values.playback))
    }
    .expandingWidthFrame(alignment: .leading)
}


// MARK: Styles
#Preview("Styles", traits: .headerFooter) {
    @Previewable @State var toggle = true

    Toggle("Toggle", isOn: $toggle)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)
    .labelStyle(.iconOnly)
}


// MARK: Comparison
#Preview("Comparison", traits: .headerFooter) {
    @Previewable @State var toggle = false

    PreviewCaption("""
        Default sizing from `PopCapsuleIconButton` is used, which matches the height of the default 
        toggle.
        """)

    let comparisonView = VStack(spacing: .zero) {
        DashedDivider()

        HStack {
            Toggle("Comparison", isOn: $toggle)
            .toggleStyle(.roundCheckmark)
            .labelStyle(.iconOnly)

            Toggle("Toggle", isOn: $toggle)
            .toggleStyle(.onlySwitch)
        }
        .debugAlignmentGuide(vertical: .top, .extendedLength(20))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(20))
        .padding(.vertical, 5)

        DashedDivider()
    }

    comparisonView

    // FIXME: Use ScaledLayout.
    comparisonView
    .scaleEffect(3)
    .padding(.vertical, 40)
}


// MARK: Standalone
#Preview("Standalone", traits: .headerFooter) {
    @Previewable @State var toggleTrue = true
    @Previewable @State var toggleFalse = false

    HStack {
        Toggle("Labeled", isOn: $toggleTrue)
        .toggleStyle(.onlySwitch)
        Text("Labeled")
    }
    .expandingWidthFrame(alignment: .leading)

    HStack {
        Toggle("Extra Style", isOn: $toggleFalse)
        .toggleStyle(.onlySwitch)
        // This external style does not apply, because `onlySwitch` forces it to switch.
        // FUTURE: roundCheckmark could display only the button, and an additional `labeled` style
        // could wrap it in a label.
        .toggleStyle(.button)
        Text("Extra Style")
    }
    .expandingWidthFrame(alignment: .leading)

    DashedDivider()

    VStack {
        Toggle("True", isOn: $toggleTrue)
            .border(.orange.secondary, width: 2)
        Toggle("False", isOn: $toggleFalse)
            .border(.orange.secondary, width: 2)
    }
    .toggleStyle(.onlySwitch)
    .scaledLayout(3)
}


// MARK: - Experimental


// Experimental, currently only works with one child.
private struct ScaledLayout: Layout {
    let scale: CGFloat

    // Proposal for the child, in unscaled coordinate space.
    private func unscaled(_ proposal: ProposedViewSize) -> ProposedViewSize {
        ProposedViewSize(
            width: proposal.width.map { $0 / scale },
            height: proposal.height.map { $0 / scale }
        )
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let subview = subviews.first else { return .zero }
        let size = subview.sizeThatFits(unscaled(proposal))
        return CGSize(width: size.width * scale, height: size.height * scale)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: unscaled(proposal))
    }
}

extension View {
    /// Scales the view and makes it occupy its scaled size in layout.
    func scaledLayout(_ scale: CGFloat) -> some View {
        ScaledLayout(scale: scale) {
            self.scaleEffect(scale)
        }
    }
}

