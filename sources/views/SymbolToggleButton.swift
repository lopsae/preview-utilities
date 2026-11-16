//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct SymbolToggleButton<FirstStyle, SecondStyle>: View
where FirstStyle: ShapeStyle, SecondStyle: ShapeStyle
{

    @Binding private var toggle: Bool

    private let titleKey: LocalizedStringKey
    private let firstStyle: FirstStyle
    private let secondStyle: SecondStyle
    private let playback: AnimationPlayback

    init(
        _ titleKey: LocalizedStringKey,
        toggle: Binding<Bool>,
        firstStyle: FirstStyle = .primary,
        secondStyle: SecondStyle = .primary,
        animations playback: AnimationPlayback = .normal
    ) {
        self.titleKey = titleKey
        self._toggle = toggle
        self.firstStyle = firstStyle
        self.secondStyle = secondStyle
        self.playback = playback
    }

    var body: some View {
        // TODO: Review how accessibility would work for this control, since the control has a title, and this
        // button  also has a title. Compare with the stock Toggle.
        Button("Toggle") {
            toggle.toggle()
        } icon: {
            ZStack {
                // FIXME: With BaselinedImageView with an empty overlay.
                // This view keeps stable the size of the button while transition are playing.
                Image(systemName: "circle")
                .hidden()

                // The ZStacks are required for the dismiss animation to perform properly.

                // Checkmark is animated with a scale+opacity fast animation.
                let checkmarkTransition: AnyTransition = .asymmetric(
                    insertion: .scale(scale: 2),
                    removal:   .scale(scale: 0.5)
                ).combined(with: .opacity)
                let checkmarkAnimation: Animation? = .default.speed(2)
                    .playback(playback)

                // Xmark is fades in with a slight delay, and fades out with scale.
                let xmarkTransition: AnyTransition = .asymmetric(
                    insertion: .identity,
                    removal:   .scale(scale: 0.5)
                ).combined(with: .opacity)
                let xmarkAnimation: Animation? = .default.speed(2).delay(toggle ? 0 : 0.2)
                    .playback(playback)

                ZStack {
                    if toggle {
                        UniformSizeSymbol(systemName: "checkmark")
                        .foregroundStyle(firstStyle)
                        .transition(checkmarkTransition)
                    }
                }.animation(checkmarkAnimation, value: toggle)


                ZStack {
                    if !toggle {
                        UniformSizeSymbol(systemName: "xmark")
                        .foregroundStyle(secondStyle)
                        .transition(xmarkTransition)
                    }
                }.animation(xmarkAnimation, value: toggle)
            }
        }
    }

}

#Preview("SymbolToggleButton") {
    @Previewable @State var toggle = true

    SymbolToggleButton("Default", toggle: $toggle)
    SymbolToggleButton("Styled", toggle: $toggle, firstStyle: .red, secondStyle: .secondary)
}
