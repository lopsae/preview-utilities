//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Button that displays two symbols with independent styles and can toggle between them.
///
/// The symbol size is stabilized using ``UniformSizeSymbol``, so that toggling between them does
/// not change the size of the button.
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

    @_documentation(visibility: internal)
    var body: some View {
        // TODO: Review how accessibility would work for this control, since the control has a title, and this
        // button  also has a title. Compare with the stock Toggle.
        Button("Toggle") {
            toggle.toggle()
        } icon: {
            ZStack {
                // This view keeps stable the size of the button while transition are playing.
                UniformSizeSymbol(systemName: "circle")
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


// MARK: - Previews


#Preview("Default", traits: .spacing(16)) {
    @Previewable @State var symbolToggle = true
    @Previewable @State var imageToggle = true

    SymbolToggleButton("Default", toggle: $symbolToggle)
    .caliperLabel("Default", to: .leading, span: 12, stem: 16, alignment: .outerTrailing, spacingSize: .square(of: 8))

    SymbolToggleButton("Styled", toggle: $symbolToggle, firstStyle: .red, secondStyle: .secondary)
    .caliperLabel("Styled", to: .leading, span: 12, stem: 16, alignment: .outerTrailing, spacingSize: .square(of: 8))

    Button("Action") {
        imageToggle.toggle()
    } icon: {
        if imageToggle {
            Image(systemName: "guidepoint.horizontal")
        } else {
            Image(systemName: "guidepoint.vertical")
        }
    }
    .caliperLabel("Using plain\nimages", to: .leading, span: 12, stem: 16, alignment: .outerTrailing, spacingSize: .square(of: 8))
}
