//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Modifications for animations in a view or controls.
///  
/// Views and controls can expose an `AnimationPlayback` property or parameter to configure the
/// internal animations all together.
nonisolated
enum AnimationPlayback: Hashable, Sendable {

    /// Animations play normally.
    case normal

    /// Animation speed is scaled by the associated speed factor.
    case scaled(CGFloat)

    /// Animations are disabled.
    case disabled

    /// Indicates if the instance is the disabled case.
    var isDisabled: Bool {
        switch self {
        case .normal:   false
        case .scaled:   false
        case .disabled: true
        }
    }

    var displayName: String {
        switch self {
        case .normal:   "normal"
        case .scaled:   "scaled"
        case .disabled: "disabled"
        }
    }

    /// Scales animation to at fifth of normal speed.
    static let slow: Self = .scaled(1/5)
}


extension Animation {

    func playback(_ playback: AnimationPlayback) -> Self? {
        switch playback {
        case .normal:            self
        case .scaled(let speed): self.speed(speed)
        case .disabled:          nil
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggle = true
    @Previewable @State var alignment: HorizontalAlignment = .leading
    @Previewable @State var playback: AnimationPlayback = .normal

    let playbacks: [AnimationPlayback] = [.normal, .slow, .disabled]
    // FIXME: Can an extension of FormatStyle<Generic, String> be done to capitalized()? Where it produces a composite?
    Picker("Playback", selection: $playback, collection: playbacks, id: \.displayName, elementFormat: .property(\.displayName))
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
