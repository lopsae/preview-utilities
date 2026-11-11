//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Toggle control with a label and a round toggle button.
struct RoundToggle: View {

    @Binding private var isOn: Bool
    private let stringKey: LocalizedStringKey

    init(_ stringKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.stringKey = stringKey
        self._isOn = isOn
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(stringKey)
            Spacer()

            let imageName = isOn ? "checkmark" : "xmark"
            let foregroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.background) : AnyShapeStyle(.primary.secondary)
            let backgroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(.gray.secondary)
            BaselinedImageView(systemName: imageName)
            .foregroundStyle(foregroundStyle)
            .padding(4)
            .background(backgroundStyle, in: .circle)
            .animation(.default.speed(5), value: isOn)
            .onTapGesture { isOn.toggle() }

            Button {
                isOn.toggle()
            } label: {
                Label {
                    Text("Toggle")
                } icon: {
                    BaselinedImageView(systemName: imageName)
                    .animation(.default.speed(5), value: isOn)
                }
            }
            .buttonStyle(AnimatedPressedButtonStyle(isOn: isOn))

            Button("Toggle") {
                isOn.toggle()
            } icon: {
                ZStack {
                    Image(systemName: "circle")
                        .hidden()

                    ZStack {
                        if isOn {
                            BaselinedImageView(systemName: "checkmark")
                            .transition(.asymmetric(
                                insertion: .scale(scale: 2)/*.combined(with: .opacity)*/,
                                removal: .scale(scale: 0.5)/*.combined(with: .opacity)*/
                            ).combined(with: .opacity))
                        }
                    }.animation(.default.speed(0.5), value: isOn)

                    ZStack {
                        if !isOn {
                            BaselinedImageView(systemName: "xmark")
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .scale(scale: 0.5).combined(with: .opacity)
                            ))
    //                        .animation(isOn ? .default.speed(0.5).delay(1.3) : .default.speed(0.5), value: isOn)
                        }
                    }
                    .animation(.default.speed(isOn ? 0.2 : 0.2).delay(isOn ? 0 : 0.5), value: isOn)


                }


//                Group {
//                    if isOn {
//                        BaselinedImageView(systemName: "checkmark")
//                        .transition(.asymmetric(
//                            insertion: .scale(scale: 2).combined(with: .opacity),
//                            removal: .scale(scale: 0.5).combined(with: .opacity)
//                        ))
//                    } else {
//                        BaselinedImageView(systemName: "xmark")
//                        .transition(.asymmetric(
//                            insertion: .opacity,
//                            removal: .scale(scale: 0.5).combined(with: .opacity)
//                        ))
//                    }
//                }
//                .animation(.default.speed(0.5), value: isOn)
            }
            .buttonStyle(AnimatedPressedButtonStyle(isOn: isOn))

        }
    }

    struct AnimatedPressedButtonStyle: ButtonStyle {
        let isOn: Bool

        func makeBody(configuration: Configuration) -> some View {
            let foregroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.background) : AnyShapeStyle(.primary.secondary)
            let backgroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(.gray.secondary)
            configuration.label
            .labelStyle(.iconOnly)
            .foregroundStyle(foregroundStyle)
            .padding(4)
            .background(backgroundStyle, in: .capsule)
            .animation(.default.speed(5), value: isOn)
            .scaleEffect(configuration.isPressed ? 1.4 : 1.0, anchor: .center)
            .animation(.bouncy(duration: 0.3, extraBounce: 0.3), value: configuration.isPressed)
        }

    }

}


#Preview("RoundToggle", traits: .fixedHeader) {
    @Previewable @State var toggleValues: [Bool] = [true, false]
    VStack($toggleValues.indexed(), id: \.index) { index, $toggleValue in
        RoundToggle("Toggle \(index)", isOn: $toggleValue)
    }
}


// FIXME: Move to its own file.
// TODO: Based/Brough from Trailing{Closure}, consider exposing or moving to its own package.
// TODO: Check what happens to the accessibility label of a label with this style.

/// Image framed to a square view size, irregardless of the image size.
private struct BaselinedImageView: View {

    private let image: Image

    init(systemName: String) {
        self.image = Image(systemName: systemName)
    }

    var body: some View {
        Image(systemName: "circle")
        .hidden()
        .overlay(alignment: .centerFirstTextBaseline) {
            image
        }
        .contentShape(.circle)
    }

}


#Preview("BaselinedImageView", traits: .paddingSpacing) {
    let imageNames = [
        "ladybug",
        "guidepoint.horizontal",
        "guidepoint.vertical",
        "minus",
        "photo.badge.shield.exclamationmark",
        "clock.badge.airplane"
    ]

    ForEach(imageNames, id: \.self) { imageName in
        BaselinedImageView(systemName: imageName)
        .floatingCaption(alignment: .outerTrailingTop, .colorStyle(.cyan), .size)
    }

    HStack(imageNames, id: \.self, spacing: 8) { imageName in
        BaselinedImageView(systemName: imageName)
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)

}
