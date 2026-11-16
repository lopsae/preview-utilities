//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Structure that produces views with a given input.
///
/// Use `ViewTemplate` to create an inline structure that produces a custom view with the given
/// parameters.
///
/// In Previews local functions cannot be defined to create repeating parametrized views. Use
/// `ViewTemplate` to create an inline local value that can create repeating views using the given
/// parameters.
struct ViewTemplate<Content: View, each Input> {

    let content: (repeat each Input) -> Content

    init(
        taking: repeat (each Input).Type,
        @ViewBuilder content: @escaping (repeat each Input) -> Content
    ) {
        self.content = content
    }

    init(@ViewBuilder content: @escaping (repeat each Input) -> Content) {
        self.content = content
    }

    @ViewBuilder func callAsFunction(_ input: repeat each Input) -> some View {
        content(repeat each input)
    }

}


// MARK: - Preview


#Preview("Default") {
    let template = ViewTemplate(taking: String.self) { titleKey in
        Label(titleKey, systemImage: "ladybug")
        DashedDivider()
    }
    template("One")
    template("Two")
    template("Three")

    // Input can be also defined by an implicit closure parameter type.
    let onlyClosure = ViewTemplate { (titleKey: String) in
        Label(titleKey, systemImage: "ant")
        DashedDivider()
    }
    onlyClosure("Uno")
    onlyClosure("Dos")
    onlyClosure("Tres")

    // Multiple inputs.
    let multiple = ViewTemplate(taking: String.self, Color.self) { imageName, color in
        Label(imageName.capitalized, systemImage: imageName)
        .foregroundStyle(color)
        DashedDivider()
    }
    multiple("leaf",  .green)
    multiple("moon",  .blue)
    multiple("flame", .red)
}
