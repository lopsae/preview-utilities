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


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggle = true
    @Previewable @State var alignment: HorizontalAlignment = .leading
    @Previewable @State var playback: AnimationPlayback = .normal

    Picker(
        "Playback", selection: $playback,
        collection: AnimationPlayback.fixedCases, id: \.displayName,
        elementFormat: .property(\.displayName).capitalized
    )
    .pickerStyle(.segmented)

    DashedDivider()

    Button("Animate") { toggle.toggle() }
    .buttonStyle(.borderedProminent)

    // FIXME: Dry into a foreach.
    CaptionRectangle("Default", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.default.playback(playback), value: alignment)

    CaptionRectangle("EaseInOut", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.easeInOut.playback(playback), value: alignment)

    CaptionRectangle("Linear", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.linear.playback(playback), value: alignment)

    CaptionRectangle("Smooth", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.smooth.playback(playback), value: alignment)

    CaptionRectangle("Snappy", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.snappy.playback(playback), value: alignment)

    CaptionRectangle("Spring", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .animation(.spring.playback(playback), value: alignment)

    CaptionRectangle("Bouncy", color: .brown, size: [100, 50])
    .expandingWidthFrame(alignment: alignment.orthogonalCenterAlignment)
    .onChange(of: toggle) {
        let newAlignment: HorizontalAlignment = toggle ? .leading : .trailing
        withAnimation(.bouncy.playback(playback)) {
            alignment = newAlignment
        }
    }
}
