//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// FIXME: Add tests.
// TODO: Check what happens to the accessibility label of a label with this style.


/// A view that displays a symbol image framed in an uniform symbol square size.
///
/// This view places the displayed image in an overlay with a fixed size based on the `circle`
/// symbol, and aligned to `centerFirstTextBaseline`. The result is a system symbol that is always
/// laid out with a uniform size, irregardless of the size of the displayed symbol.
///
/// The view respects the environment foreground style, image scale, and related modifiers.
///
/// Based on: https://trailing-closure.com/2026/intricacies-of-circular-buttons.
public struct UniformSizeSymbol: View {

    private let image: Image

    /// Creates a view displaying a system symbol image.
    ///
    /// - Parameter systemName: The name of the system symbol image.
    public init(systemName: String) {
        self.image = Image(systemName: systemName)
    }

    @_documentation(visibility: internal)
    public var body: some View {
        Image(systemName: "circle")
        .hidden()
        .overlay(alignment: .centerFirstTextBaseline) {
            image
        }
        .contentShape(.circle)
    }

}


#Preview("Default", traits: .paddingSpacing) {
    let imageNames = [
        "ladybug",
        "guidepoint.horizontal",
        "guidepoint.vertical",
        "minus",
        "photo.badge.shield.exclamationmark",
        "clock.badge.airplane"
    ]

    ForEach(imageNames, id: \.self) { imageName in
        UniformSizeSymbol(systemName: imageName)
        .floatingCaption(alignment: .outerTrailingTop, .colorStyle(.cyan), .size)
    }

    HStack(imageNames, id: \.self, spacing: 8) { imageName in
        UniformSizeSymbol(systemName: imageName)
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)

}
