//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// View that displays two symbols with independent styles and can toggle between them.
///
/// The symbol size is stabilized using ``UniformSizeSymbol``, so that toggling between them does
/// not change the size of the view.
struct SymbolToggle<FirstStyle, SecondStyle>: View
where FirstStyle: ShapeStyle, SecondStyle: ShapeStyle
{

    private let toggle: Bool
    private let firstStyle: FirstStyle
    private let secondStyle: SecondStyle
    private let playback: AnimationPlayback

    init(
        toggle: Bool,
        firstStyle: FirstStyle = .primary,
        secondStyle: SecondStyle = .primary,
        animations playback: AnimationPlayback = .normal
    ) {
        self.toggle      = toggle
        self.firstStyle  = firstStyle
        self.secondStyle = secondStyle
        self.playback    = playback
    }

    @_documentation(visibility: internal)
    var body: some View {
        ZStack {
            // This view keeps stable the size of the button while transition are playing.
            // During some transitions there is chance no symbol is displayed, and the size of the
            // view would collapse to zero.
            UniformSizeSymbol(systemName: "circle")
            .hidden()

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

            // The ZStacks are required for the dismiss animation to perform properly for each view.

            // TODO: Review how accessibility would work for this set of images.

            // FUTURE: Could this be parametrized to any number of symbols, each with its own transition
            // and animations values?

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


// MARK: - Previews


#Preview("Default", traits: .spacing(16)) {
    @Previewable @State var symbolToggle = true
    @Previewable @State var imageToggle = true

    SymbolToggle(toggle: symbolToggle)
    .caliperLabel("Default", from: .trailing)
 
    SymbolToggle(toggle: symbolToggle, firstStyle: .red, secondStyle: .secondary)
    .caliperLabel("Styled", from: .trailing)

    Button("Toggle") { symbolToggle.toggle() }

    Image(systemName: imageToggle ? "guidepoint.horizontal" : "guidepoint.vertical")
    .caliperLabel("Stock Image", from: .trailing)

    Button("Toggle") { imageToggle.toggle() }
}


// FIXME: Move to Caliper.
extension View {

    // Currently has fixed span and stem, how to make the span take the length of the view?
    @ContentBuilder
    func caliperLabel(
        _ key: LocalizedStringKey,
        from edge: Edge,
        span: CGFloat = 12,
        stem: CGFloat = 16,
        spacing: CGFloat = 8
    ) -> some View {
        let alignment: FloatingAlignment = switch edge {
        case .top:      .outerTop
        case .leading:  .outerLeading
        case .bottom:   .outerBottom
        case .trailing: .outerTrailing
        }

        self.caliperLabel(
            key,
            to: edge.opposite,
            span: span,
            stem: stem,
            alignment: alignment,
            spacingSize: .square(of: spacing)
        )
    }

}
