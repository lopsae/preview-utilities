//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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


// MARK: Standalone
#Preview("Standalone", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var toggleTrue = true
    @Previewable @State var toggleFalse = false

    HStack {
        Toggle("Only Switch", isOn: $toggleTrue)
        .toggleStyle(.onlySwitch)
        Text("Only Switch")
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

