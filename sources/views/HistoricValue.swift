//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Displays a value, along a history of previous values offset from the view.
///
/// Every time the displayed value changes the previous value is stored. All stored values are
/// displayed offset of the current value, towards an specified edgde.
struct HistoricValue<Value: Equatable, Formatter: FormatStyle>: View
where
    Formatter.FormatInput == Value,
    Formatter.FormatOutput == String
{

    @State private var history: [History] = []
    @Binding private var isMarked: Bool

    /// Current value.
    let value: Value
    /// Formatter to transform `value` to a string to display.
    let formatter: Formatter

    /// Number of changes of values to keep in history.
    let historyLength: Int = 10

    /// Space between the value view and the first historic value.
    private(set) var historyPadding: Double = 5

    /// Space between each historic value.
    private(set) var historySpacing: Double = 16
    /// Direction in which the historic values are displayed.
    private(set) var historyEdge: Edge = .bottom



    /// Creates a view which displays a formatted value along its history of previous values.
    init(value: Value, isMarked: Binding<Bool> = .constant(false), format formatter: Formatter) {
        self.value = value
        self._isMarked = isMarked
        self.formatter = formatter
    }


    var body: some View {
        let valueString = formatter.format(value)
        Text(valueString)
        .monospacedDigit()
        .background {
            if isMarked {
                markedCapsule(.blue.secondary)
            }
        }
        // Historic values placed in an overlay so that these never modify the size of the
        // main text.
        .overlay {
            historicValues
        }
        .onChange(of: value) { oldValue, newValue in
            if history.count >= historyLength {
                history.removeLast(1 + history.count - historyLength)
            }
            let historyItem = History(value: oldValue, marked: isMarked)
            history.insert(historyItem, at: 0)
            isMarked = false
        }
    }


    /// Configures the instance with the given parameters.
    func configure(
        padding: Double? = nil,
        spacing: Double? = nil,
        edge: Edge? = nil
    ) -> Self {
        var copy = self
        if let padding { copy.historyPadding = padding }
        if let spacing { copy.historySpacing = spacing }
        if let edge    { copy.historyEdge    = edge }
        return copy
    }


    /// View of all the stored historic values. Each valie is displayed towards `historyEdge`.
    /// More recent values are displayed closer to the current value, older values are displayed
    /// farther away.
    @ViewBuilder
    private var historicValues: some View {
        ForEach(history.enumerated(), id: \.offset) { index, historyItem in
            let valueString = formatter.format(historyItem.value)
            let offsetValue = ((index.asDouble + 1.0) * historySpacing) + historyPadding
            let offsetSize = switch historyEdge {
            case .top:      CGSize(width: .zero, height: -offsetValue)
            case .leading:  CGSize(width: -offsetValue, height: .zero)
            case .bottom:   CGSize(width: .zero, height: offsetValue)
            case .trailing: CGSize(width: offsetValue, height: .zero)
            }

            Text(valueString)
            .font(.caption)
            .monospacedDigit()
            .fixedSize()
            .background {
                if historyItem.marked {
                    markedCapsule(.blue.tertiary)
                }
            }
            .opacity(1.0 - (index.asDouble / historyLength.asDouble))
            .offset(offsetSize)
        }
    }


    private func markedCapsule(_ style: some ShapeStyle) -> some View {
        Capsule()
        .fill(style)
        .padding(.horizontal, -Defaults.padding/2)
        .padding(.vertical, -Defaults.padding/4)
    }

}


// MARK: - HistoryItem


extension HistoricValue {

    // TODO: rename to HistoryItem.
    struct History {
        let value: Value
        let marked: Bool
    }

}


// MARK: - Convenience initializers


extension HistoricValue {

    /// Creates a view which displays a string value along its history of previous values.
    init(value: Value, isMarked: Binding<Bool> = .constant(false))
    where
        Formatter == IdentityFormatStyle<Value>,
        Value == String
    {
        self.init(value: value, isMarked: isMarked, format: .init())
    }


    /// Creates a view which displays the string description of a value along its history of
    /// previous values.
    init(describingValue value: Value, isMarked: Binding<Bool> = .constant(false))
    where Formatter == StringDescriptionFormatStyle<Value>
    {
        self.init(value: value, isMarked: isMarked, format: .init())
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    static var star: some View {
        StarShape(points: 6, concaveVertexRatio: 0.8)
            .fill(.pink.gradient)
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var selectedIndex: Int = 0
    @Previewable @State var isMarked: Bool = false
    @Previewable @State var historyEdge: Edge = .bottom
    let values = Strings.natoPhoneticAlphabet
    let selection = values[selectedIndex]

    VisibleSpacer()

    HistoricValue(value: selection, isMarked: $isMarked)
        .configure(/*padding: 10, spacing: 40, */edge: historyEdge)

    VisibleSpacer()

    Text.caption("Change value:")
        .padding(.top)

    HStack {
        Button("Previous", constrainedSystemImage: "arrowshape.left") {
            selectedIndex = (selectedIndex + values.count - 1) % values.count
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)

        Button("Mark", constrainedSystemImage: isMarked ? "circle.fill" : "circle") {
            isMarked.toggle()
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)

        Button("Next", constrainedSystemImage: "arrowshape.right") {
            selectedIndex = (selectedIndex + 1) % values.count
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }

    VStack {
        Text.caption("History direction:")
        Button("Top", constrainedSystemImage: "arrowshape.up.fill") {
            historyEdge = .top
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
        .tint(historyEdge == .top ? .cyan : .indigo)

        HStack {
            Button("Leading", constrainedSystemImage: "arrowshape.left.fill") {
                historyEdge = .leading
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
            .tint(historyEdge == .leading ? .cyan : .indigo)

            Button("Bottom", constrainedSystemImage: "arrowshape.down.fill") {
                historyEdge = .bottom
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
            .tint(historyEdge == .bottom ? .cyan : .indigo)

            Button("Trailing", constrainedSystemImage: "arrowshape.right.fill") {
                historyEdge = .trailing
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
            .tint(historyEdge == .trailing ? .cyan : .indigo)
        }
    }

}


#Preview("Formatted", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 0.12345
    @Previewable @State var isMarked: Bool = false
    @Previewable @State var useFormatter: Bool = true
    let step: Double = 0.12345

    VStack(alignment: .leading) {
        if useFormatter {
            HistoricValue(value: value, isMarked: $isMarked, format: .fractionLength(2))
                .configure(spacing: 35, edge: .trailing)
        } else {
            HistoricValue(describingValue: value, isMarked: $isMarked)
                .configure(padding: 10, edge: .top)
        }

        Text("raw: \(value)")
            .font(.caption)
            .monospacedDigit()
        Text("Using \(useFormatter ? "Short Fraction" : "Default (String Description)")")
            .font(.caption)

        HStack {
            Button("Substract", constrainedSystemImage: "minus") { value -= step }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)

            Button("Mark", constrainedSystemImage: isMarked ? "circle.fill" : "circle") {
                isMarked.toggle()
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)

            Button("Add", constrainedSystemImage: "plus") { value += step }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
        } // HStack
    } // VStack
    .maxWidthFrame(alignment: .leading)

    Toggle("Use Formatter", isOn: $useFormatter)
}
