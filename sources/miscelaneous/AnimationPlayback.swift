//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Modifications for animations in a view or control.
///
/// Views and controls can expose an `AnimationPlayback` property or parameter to configure its
/// internal animations.
nonisolated
enum AnimationPlayback: Hashable, Sendable {

    /// Animations play normally.
    case normal

    /// Animations play at a fifth of the normal speed.
    case slow

    /// Animations are disabled.
    case disabled

    /// Animation speed is scaled by the associated speed factor.
    case scaled(CGFloat)

    /// Indicates if the instance is the disabled case.
    var isDisabled: Bool {
        switch self {
        case .normal:   false
        case .slow:     false
        case .scaled:   false
        case .disabled: true
        }
    }

    var displayName: String {
        switch self {
        case .normal:   "normal"
        case .slow:     "slow"
        case .disabled: "disabled"
        case .scaled:   "scaled"
        }
    }

    /// A collection of all cases of this type with fixed values.
    static let fixedCases: [Self] = [.normal, .slow, .disabled]

}


extension Animation {

    func playback(_ playback: AnimationPlayback) -> Self? {
        switch playback {
        case .normal:            self
        case .slow:              self.speed(1/5)
        case .disabled:          nil
        case .scaled(let speed): self.speed(speed)
        }
    }

}


extension Animation {

    /// A collection of all cases of this type with fixed values.
    static let fixedCases: [Self] = [
        .default, .linear,
        .easeIn, .easeOut, .easeInOut,
        .snappy, .bouncy, .smooth, .spring,
        .interactiveSpring, .interpolatingSpring,
    ]

    /// A collection of all cases of this type with fixed values, excluding those intended for
    /// interactive or interpolated animations.
    static let fixedSimpleCases: [Self] = [
        .default, .linear,
        .easeIn, .easeOut, .easeInOut,
        .snappy, .bouncy,
        .smooth, .spring,
    ]

    static let fixedSimpleDisplayCases: [DisplayProperty<Self>] = [
        DisplayProperty("default", value: .default),
        DisplayProperty("linear", value: .linear),
        DisplayProperty("ease in", value: .easeIn),
        DisplayProperty("ease out", value: .easeOut),
        DisplayProperty("ease in out", value: .easeInOut),
        DisplayProperty("snappy", value: .snappy),
        DisplayProperty("bouncy", value: .bouncy),
        DisplayProperty("smooth", value: .smooth),
        DisplayProperty("spring", value: .spring),
    ]

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggle = true
    @Previewable @State var alignment: HorizontalAlignment = .leading
    @Previewable @State var playback: AnimationPlayback = .normal

    @Previewable @State var toggles: [
        (property: DisplayProperty<Animation>, toggle: Bool)
    ] = Animation.fixedSimpleDisplayCases.map { property in
        (property, true)
    }

    Picker(
        "Playback", selection: $playback,
        collection: AnimationPlayback.fixedCases, id: \.displayName,
        elementFormat: .capitalize(property: \.displayName)
    )
    .pickerStyle(.segmented)

    DashedDivider()

    ForEach($toggles, id: \.wrappedValue.property.displayString) { $tuple in
        ZStack {
            let caption = tuple.property.displayString.formatted(.capitalize.removingSpaces)
            let alignment: HorizontalAlignment = tuple.toggle ? .leading : .trailing
            CaptionRectangle("\(caption)", color: .brown, size: [100, 50])
            .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
            .animation(tuple.property.value.playback(playback), value: alignment)

            Button("Animate") { tuple.toggle.toggle() }
        }
    }
}


// FIXME: Move to FormatStyles

nonisolated
struct RemoveSpacesFormatStyle: FormatStyle, Sendable {

    public init() {}

    public func format(_ value: String) -> String {
        return value.components(separatedBy: .whitespaces).joined()
    }

}


extension FormatStyle where Self == RemoveSpacesFormatStyle {

    nonisolated
    static var removeSpaces: Self { RemoveSpacesFormatStyle() }

}


extension FormatStyle where Self: Sendable, FormatOutput == String {

    nonisolated
    var removingSpaces: CompositeFormatStyle<Self, RemoveSpacesFormatStyle> {
        return CompositeFormatStyle(input: self, output: .removeSpaces)
    }

}
