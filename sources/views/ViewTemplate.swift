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
    init(taking: Input.Type, @ViewBuilder content: @escaping (Input) -> Content) {
        self.content = content
    }
    @ViewBuilder func callAsFunction(_ parameter: Input) -> some View {
        content(parameter)
    }
}
