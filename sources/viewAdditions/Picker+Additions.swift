//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// `ForEach` implicitly constrains `ValuesCollection `to `RandomAccessCollection`, and `ElementID`
// to `Hashable`, as specified in its struct definition. The constraints in this initializers to
// `RandomAccessCollection` and `Hashable` are not not strictly necessary (the initializers would
// still work without them) but are made implicit for completeness.

// For the initializers that use self-identified elements: an `Elent: Identifiable` constraint along
// an `ID: Element` is preferred over a constraint to `SelfIdentifiable`. With the preferred
// constraint the compiler checks for the constraint that `SelfIndentifible` implicitly requires,
// and will also detect if a type overrides the default `id` provided by `SelfIdentifiable`.


// MARK: Collection of Values + ID KeyPath + ViewBuilder
// + Selection value binding.
// + Collection of possible selection values.
// + ID KeyPath.
// + ViewBuilder for each element.

extension Picker {

    /// Creates a picker that generates its label and creates the option views with the elements
    /// of the given collection. The collection contains the possible selection values, and each
    /// element is identified with the given keypath.
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf as the picker label, using
    /// a given localized key.
    ///
    /// The views created by `elementContent` are automatically tagged with their corresponding
    /// element.
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
        SelectionValue == ValuesCollection.Element,
        Label == Text,
        Content == ForEach<ValuesCollection, ElementID, TaggedView<ElementContent, SelectionValue>>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(collection, id: idKeyPath) { element in
                    TaggedView(tag: element) {
                        elementContent(element)
                    }
                }
            }
        )
    }

}


#Preview("Collection+IdKeyPath+View", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var nonIdentifiedValue: PreviewContent.NonidentifiedValues = .john

    PreviewCaption("""
        Picker with a collection of **non-identifiable** elements, with a **view-builder** for
        each collection element.
        """)

    Text("Value: \(nonIdentifiedValue.rawValue)")
        .monospaced()
    Picker(
        "NonIdentifiable Picker",
        selection: $nonIdentifiedValue,
        collection: PreviewContent.NonidentifiedValues.allCases,
        id: \.rawValue
    ) { value in
        Label(value.rawValue.capitalized, systemImage: "ladybug")
    }.pickerStyle(.segmented)
}


// MARK: Collection of Values + ID KeyPath + ViewBuilder
// + Selection value binding.
// + Collection of Identifiable values, possible selection values.
// + ViewBuilder for each element.

extension Picker {

    /// Creates a picker that generates its label and creates the option views with the elements
    /// of a given collection of `Identifiable` elements. The collection contains the possible
    /// selection values
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf as the picker label, using
    /// a given localized key.
    ///
    /// The views created by `elementContent` are automatically tagged with their corresponding
    /// element.
    init<ValuesCollection, ElementContent>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        collection: ValuesCollection,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ValuesCollection.Element: Identifiable,
        ElementContent: View,
        SelectionValue == ValuesCollection.Element,
        Label == Text,
        Content == ForEach<ValuesCollection, ValuesCollection.Element.ID, TaggedView<ElementContent, SelectionValue>>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(collection) { element in
                    TaggedView(tag: element) {
                        elementContent(element)
                    }
                }
            }
        )
    }

}


#Preview("Id'dCollection+View", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var identifiedValue: PreviewContent.IdentifiedValues = .bob

    PreviewCaption("""
        Picker with a collection of **identifiable** elements, with a **view-builder** for each 
        collection element.
        """)

    Text("Value: \(identifiedValue.rawValue)")
        .monospaced()
    Picker(
        "Identifiable Picker",
        selection: $identifiedValue,
        collection: PreviewContent.IdentifiedValues.allCases
    ) { value in
        Text(value.rawValue.capitalized)
    }.pickerStyle(.segmented)
}


extension Picker {

    // MARK: Self-Identifiables Collection + ViewBuilder
    // + Selection Value
    // + Collection of Self-Identifiable values
    // + ViewBuilder for each element.

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


    // MARK: Collection of Values + ID KeyPath + Element Format
    // + Selection Value
    // + Collection of possible values
    // + ID KeyPath
    // + Formatter for producing Texts

    /// Creates a picker that generates its label and option views with the formatted elements of a
    /// given collection identified through a key path.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the picker label, and transforming the selection values through a format style for their
    /// respective labels.
    init<ValuesCollection, ElementID>(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        collection: ValuesCollection,
        id idKeyPath: KeyPath<ValuesCollection.Element, ElementID>,
        elementFormat: any FormatStyle<SelectionValue, String>
    ) where
        ValuesCollection: RandomAccessCollection,
        ValuesCollection.Element == SelectionValue,
        ElementID: Hashable,
        Label == Text,
        Content == ForEach<ValuesCollection, ElementID, TaggedText<SelectionValue>>
    {
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(collection, id: idKeyPath) { element in
                    let string = elementFormat.format(element)
                    TaggedText(verbatim: string, tag: element)
                }
            }
        )
    }


    // MARK: Self-Identifiables Collection + Element Format
    // + Selection Value
    // + Collection of Self-Identifiable values
    // + Formatter for producing Texts

    /// Creates a picker that generates its label and option views with the formatted elements of a
    /// given collection of possible selection values.
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


    // MARK: Case-Self-Identifiables Value + Case Formatter
    // + Selection Value that Self-Identifies and is Case Iterable.
    // + Formatter for producing Texts

    /// Creates a picker that generates its label and option views with the formatted cases of a
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


    // MARK: Only Case-Self-Identifiables Value
    // + Selection Value that Self-Identifies and is Case Iterable.

    /// Creates a picker that generates its label and option views with the raw values of the cases
    /// of a `CaseIterable` selection value.
    ///
    /// The selection type is constrained to `CaseIterable` to retrieve the possible selection
    /// values, to a string `RawRepresentable` to generate its option views, and to an
    /// `Identifiable` that self-identifies, that is, in which the `ID` type is itself.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the picker label, and raw values of all the cases of the selection value type.
    init(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>
    ) where
        SelectionValue: RawRepresentable & CaseIterable & Identifiable & Sendable,
        SelectionValue.ID == SelectionValue,
        SelectionValue.RawValue: StringProtocol,
        Label == Text,
        Content == ForEach<SelectionValue.AllCases, SelectionValue, Text>
    {
        let allCases = SelectionValue.allCases
        self.init(
            title,
            selection: selection,
            content: {
                ForEach(allCases) { element in
                    Text(element.rawValue)
                }
            }
        )
    }


}


// MARK: - PreviewContent


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


// MARK: EXPERIMENTAL: TaggedText

// FUTURE: if used elsewhere consider moving to its own file and add previews to ascertain it works.

/// Text with a tag. Used instead of the `.tag` modifier when a concrete type is necessary.
///
/// Used to provide a concrete-type for type-constraints in extended inits. In cases where views
/// produced by a `ForEach` need to be tagged, this type can be used to provide a concrete type in
/// type constraints. The usual `.tag` modifier cannot be used since it returns an opaque
/// `some View`.
struct TaggedText<Tag>: View where Tag: Hashable {
    let string: String
    let tag: Tag

    init(verbatim: String, tag: Tag) {
        self.string = verbatim
        self.tag = tag
    }

    var body: some View {
        Text(verbatim: string).tag(tag)
    }
}


// MARK: EXPERIMENTAL: TaggedView

// FUTURE: if used elsewhere consider moving to its own file and add previews to ascertain it works.

/// View with a tag. Used instead of the `.tag` modifier when a concrete type is necessary.
///
/// Used to provide a concrete-type for type-constraints in extended inits. In cases where views
/// produced by a `ForEach` need to be tagged, this type can be used to provide a concrete type in
/// type constraints. The usual `.tag` modifier cannot be used since it returns an opaque
/// `some View`.
struct TaggedView<Content, Tag>: View
where Content: View, Tag: Hashable
{
    let content: () -> Content
    let tag: Tag

    init(tag: Tag, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.tag = tag
    }

    var body: some View {
        content()
        .tag(tag)
    }
}


// MARK: - Previews


#Preview("Identifiable", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var identifiedValue: PreviewContent.IdentifiedValues = .bob
    @Previewable @State var selfIdentifiedValue: PreviewContent.SelfIdentifiedValues = .heidi

    VStack(alignment: .leading) {
//        PreviewCaption("Picker with a collection of **identifiable** elements.")
//        Text("Value: \(identifiedValue.rawValue)")
//            .monospaced()
//        Picker(
//            "Identifiable Picker",
//            selection: $identifiedValue,
//            collection: PreviewContent.IdentifiedValues.allCases
//        ) { value in
//            // Id is not self, tag is required for selection to work.
//            Text(value.rawValue.capitalized).tag(value)
//        }.pickerStyle(.segmented)
//
//        DashedDivider()

        PreviewCaption("Picker with a collection of **self-identifiable** elements.")
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
    } // VStack
}


#Preview("Formatted", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var nonIdentifiedValue: PreviewContent.NonidentifiedValues = .john

    VStack(alignment: .leading) {
        PreviewCaption("Picker with a collection of **non-identifiable** elements, using a **format style**.")
        Text("Value: \(nonIdentifiedValue.rawValue)")
            .monospaced()
        Picker(
            "NonIdentifiable Picker",
            selection: $nonIdentifiedValue,
            collection: PreviewContent.NonidentifiedValues.allCases,
            id: \.rawValue,
            elementFormat: .rawValueCapitalized()
        ).pickerStyle(.segmented)
    }
}


#Preview("Formatted+SelfId", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var values: PreviewContent.SelfIdentifiedValues = .heidi

    VStack(alignment: .leading) {
        PreviewCaption("Picker with a collection of **self-identifiable** elements, using a **format style**.")
        Text("Value: \(values.rawValue)")
            .monospaced()
        Picker(
            "Formatted Picker",
            selection: $values,
            selectables: PreviewContent.SelfIdentifiedValues.allCases,
            elementFormat: .rawValue()
        ).pickerStyle(.segmented)

        DashedDivider()

        PreviewCaption("Picker with a `CaseIterable` and **self-identifiable** selection value, using a **composite format style**.")
        Text("Value: \(values.rawValue)")
            .monospaced()
        Picker(
            "Formatted Picker",
            selection: $values,
            caseFormat: .firstCharacter(capitalized: true, input: .rawValue())
        ).pickerStyle(.segmented)

        DashedDivider()

        PreviewCaption("Picker with a `CaseIterable`, `RawRepresentable` and **self-identifiable** selection value **only**.")
        Text("Value: \(values.rawValue)")
            .monospaced()
        Picker("Formatted Picker", selection: $values)
            .pickerStyle(.segmented)
    } // VStack
}




