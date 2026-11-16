//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Structure that produces views with a given input.
///
/// Use `ViewTemplate` to create an inline structure that produces a custom view with a given
/// parameter. For example in Previews, where a local function cannot be created for repeating
/// parametrized views, create a `ViewTemplate` based in a parameter.
struct ViewTemplate<Content: View, Input> {

    let content: (Input) -> Content

    init(
        taking: Input.Type = Input.self,
        @ViewBuilder content: @escaping (Input) -> Content
    ) {
        self.content = content
    }

    @ViewBuilder func callAsFunction(_ parameter: Input) -> some View {
        content(parameter)
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
}
