//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Picker {

    // ForEach makes an implicit constrain of ValuesCollection to RandomAccessCollection, and
    // ElementID to Hashable given its struct definition. The constrains in this initializers are
    // not strictly necessary. Still, these are left here for completeness.


    /// Creates a picker that generates its label and creates the option views with the elements
    /// of a given collection identified through a key path.
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf as the picker label, using
    /// a given localized key.
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


    /// Creates a picker that generates its label and creates the option views with the elements
    /// of a given collection of `Identifiable` elements.
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf as the picker label, using
    /// a given localized key.
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


    /// Creates a picker that generates its label and creates the option views with the elements
    /// of a given collection of possible selection values which type self-identifies.
    ///
    /// The selection type and the elements of the collection are constrained to an `Identifiable`
    /// which `ID` type is itself.
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf as the picker label, using
    /// a given localized key.
    init<ValuesCollection, ElementContent>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        selectables: ValuesCollection,
        @ViewBuilder elementContent: @escaping (SelectionValue) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        // Identifiable is preferred over SelfIdentifiable here. This way SelfIdentifiable is not
        // required, and the compiler will detect if a type overrides the default `id` provided by
        // SelfIdentifiable.
        ValuesCollection.Element: Identifiable,
        ValuesCollection.Element == SelectionValue,
        ValuesCollection.Element.ID == SelectionValue,
        ElementContent: View,
        Label == Text,
        Content == ForEach<ValuesCollection, SelectionValue, ElementContent>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(selectables) { element in
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


    enum SelfIdentifiedValues: String, SelfIdentifiable, CaseIterable {
        case  grace, heidi, ivan, judy
    }

}


#Preview("Identifiable", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var nonIdentifiedValue: PreviewContent.NonidentifiedValues = .john
    @Previewable @State var identifiedValue: PreviewContent.IdentifiedValues = .bob
    @Previewable @State var selfIdentifiedValue: PreviewContent.SelfIdentifiedValues = .heidi

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
            // Id is not self, tag is required for selection to work.
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
            // Id is not self, tag is required for selection to work.
            Text(value.rawValue.capitalized).tag(value)
        }.pickerStyle(.segmented)

        // TODO: Use Preview Caption
        Text("Picker with a collection of **self-identifiable** elements.")
            .font(.caption)
            .padding(.top)
        Text("Value: \(selfIdentifiedValue.rawValue)")
            .monospaced()
        Picker(
            "SelfIdentifiable Picker",
            selection: $selfIdentifiedValue,
            selectables: PreviewContent.SelfIdentifiedValues.allCases,
        ) { value in
            // No tag needed!
            Text(value.rawValue.capitalized)
        }.pickerStyle(.segmented)
    }
    .padding(.horizontal)
}
