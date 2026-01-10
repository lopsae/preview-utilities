//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Picker {

    // ForEach makes an implicit constrain of ValuesCollection to RandomAccessCollection, and
    // ElementID to Hashable given its struct definition. The constrains in this initializers are
    // not strictly necessary. Still, these are left here for completeness.

    // For the initializers that use self-identified elements, an Identifiable constraint is
    // preferred over SelfIdentifiable. With that constraint SelfIdentifiable is not required, and
    // the compiler will detect if a type overrides the default `id` provided by SelfIdentifiable.


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
    /// of a given collection of possible selection values.
    ///
    /// The selection type and the elements of the collection are constrained to an `Identifiable`
    /// that self-identifies, that is, in which the `ID` type is itself.
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


    /// Creates a picker that generates its label and the option views with the formatted elements
    /// of a given collection of possible selection values.
    ///
    /// The selection type and the elements of the collection are constrained to an `Identifiable`
    /// that self-identifies, that is, in which the `ID` type is itself.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the picker label, and transforming the selection values through a format style for their
    /// respective labels.
    init<ValuesCollection>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        selectables: ValuesCollection,
        elementFormat: any FormatStyle<SelectionValue, String>
    ) where
        ValuesCollection: RandomAccessCollection,
        ValuesCollection.Element: Identifiable,
        ValuesCollection.Element == SelectionValue,
        ValuesCollection.Element.ID == SelectionValue,
        Label == Text,
        Content == ForEach<ValuesCollection, SelectionValue, Text>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(selectables) { element in
                    Text(element, format: elementFormat)
                }
            }
        )
    }


    /// Creates a picker that generates its label and the option views with the formatted cases of a
    /// `CaseIterable` selection value.
    ///
    /// The selection type is constrained to `CaseIterable` to retrieve the possible selection
    /// values, and to an `Identifiable` that self-identifies, that is, in which the `ID` type is
    /// itself.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the picker label, and transforming the posible selection values through a format style for
    /// their respective labels.
    init(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        caseFormat: any FormatStyle<SelectionValue, String>
    ) where
        SelectionValue: CaseIterable & Identifiable & Sendable,
        SelectionValue.ID == SelectionValue,
        Label == Text,
        Content == ForEach<SelectionValue.AllCases, SelectionValue, Text>
    {
        let allCases = SelectionValue.allCases
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(allCases) { element in
                    Text(element, format: caseFormat)
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


#Preview("Formatted", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var values: PreviewContent.SelfIdentifiedValues = .heidi

    VStack(alignment: .leading) {
        // TODO: Use Preview Caption
        Text("Picker with a collection of **self-identifiable** elements, using a **format style**.")
            .font(.caption)
        Text("Value: \(values.rawValue)")
            .monospaced()
        Picker(
            "Formatted Picker",
            selection: $values,
            selectables: PreviewContent.SelfIdentifiedValues.allCases,
            elementFormat: .rawValue()
        ).pickerStyle(.segmented)

        // TODO: Use Preview Caption
        Text("Picker with a `CaseIterable` and **self-identifiable** selection value, using a **composite format style**.")
            .font(.caption)
            .padding(.top)
        Text("Value: \(values.rawValue)")
            .monospaced()
        Picker(
            "Formatted Picker",
            selection: $values,
            caseFormat: .firstCharacter(capitalized: true, format: .rawValue())
        ).pickerStyle(.segmented)
    }
    .padding(.horizontal)
}




