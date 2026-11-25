//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A picker to select a floating alignment.
struct FloatingAlignmentPicker: View {

    @Binding private var alignment: FloatingAlignment

    let toggleLength: CGFloat = 28
    let toggleSpacing: CGFloat = 12
    let edgeSpacing: CGFloat = 4


    init(alignment: Binding<FloatingAlignment>) {
        self._alignment = alignment
    }


    var body: some View {
        Rectangle()
        .stroke(.gray.secondary)
        .frame(size: .square(of: toggleLength*3 + toggleSpacing*2 + edgeSpacing*2))
        .overlay {
            ForEach(FloatingAlignment.allCases) { floatingAlignment in
                FloatingAlignedContainer(alignment:floatingAlignment ,spacing: edgeSpacing) { contentAlignments in
                    let isOn = Binding<Bool> {
                        alignment == floatingAlignment
                    } set: { newValue in
                        if newValue {
                            alignment = floatingAlignment
                        }
                    }

                    Toggle("Toggle", isOn: isOn)
                    .toggleStyle(.roundCheckmark)
                    .labelStyle(.iconOnly)
                    .frame(squareOf: toggleLength)
                }
            }
        }
        .padding(toggleLength + edgeSpacing)
    }

}


// MARK: - Previews


#Preview("Default") {
    @Previewable @State var alignment: FloatingAlignment = .center

    Text.caption(verbatim: alignment.displayName.capitalized)
    FloatingAlignmentPicker(alignment: $alignment)
    .floatingCaption(
        "`FloatingAlignmentPicker`",
        alignment: .outerBottom,
        .colorStyle(.yellow)
    )
}
