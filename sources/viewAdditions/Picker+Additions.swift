//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Picker {


    init<ValuesCollection, ElementContent, ElementID>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        collection: ValuesCollection,
        id idKeyPath: KeyPath<ValuesCollection.Element, ElementID>,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ElementContent: View,
        ElementID: Hashable,
        Label == Text,
        Content == ForEach<ValuesCollection, ElementID, ElementContent>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(collection, id: idKeyPath) { element in
                    elementContent(element)
                }
            }
        )
    }


    init<ValuesCollection, ElementContent>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        collection: ValuesCollection,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ValuesCollection.Element: Identifiable,
        ElementContent: View,
        Label == Text,
        Content == ForEach<ValuesCollection, ValuesCollection.Element.ID, ElementContent>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(collection) { element in
                    elementContent(element)
                }
            }
        )
    }


}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    enum NonidentifiedValues: String, CaseIterable {
        case jane, john, janie, fred
    }

    enum IdentifiedValues: String, Identifiable, CaseIterable {
        case  alice, bob, charlie, dave
        var id: String { self.rawValue }
    }

}


#Preview("Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var nonIdentifiedValue: PreviewContent.NonidentifiedValues = .john
    @Previewable @State var identifiedValue: PreviewContent.IdentifiedValues = .bob

    VStack(alignment: .leading) {
        // TODO: Use Preview Caption
        Text("Picker with a collection of **non-identifiable** elements.")
            .font(.caption)

        Text("Value: \(nonIdentifiedValue.rawValue)")
            .monospaced()

        Picker(
            "NonIdentifiable Picker",
            selection: $nonIdentifiedValue,
            collection: PreviewContent.NonidentifiedValues.allCases,
            id: \.rawValue
        ) { value in
            Text(value.rawValue.capitalized).tag(value)
        }.pickerStyle(.segmented)

        // TODO: Use Preview Caption?
        Text("Picker with a collection of **identifiable** elements.")
            .font(.caption)
            .padding(.top)
        Text("Value: \(identifiedValue.rawValue)")
            .monospaced()
        Picker(
            "Identifiable Picker",
            selection: $identifiedValue,
            collection: PreviewContent.IdentifiedValues.allCases
        ) { value in
            Text(value.rawValue.capitalized).tag(value)
        }.pickerStyle(.segmented)
    }
    .padding(.horizontal)
}
