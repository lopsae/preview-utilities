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
