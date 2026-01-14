//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental labeling for interactive preview elements, specially rectangles.
struct FloatingCaptionModifier: ViewModifier {

    let localizedKey: LocalizedStringKey
    let traits: [Trait]

    func body(content: Content) -> some View {
        content
        .border(.quaternary, width: traits.containsCase(.border) ? 1 : .zero)
        .overlay {
            GeometryReader { geometry in
                let alignment = traits.alignment ?? .inner(.center)
                let padding: CGFloat? = traits.containsCase(.padding)
                    ? traits.padding // The trait can specify nil for a default padding.
                    : 2 // Default of 2 without trait.
                FloatingAlignedContainer(alignment: alignment) { alignment, textAlignment in
                    VStack(alignment: alignment.horizontal) {
                        Text(localizedKey)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .multilineTextAlignment(textAlignment)

                        // Width, Height, or Size.
                        Group {
                            // TODO: if traits is a Set, this could use set operations.
                            let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)
                            if traits.containsCase(.width) && traits.containsCase(.height) {
                                let formattedWidth = geometry.size.width.formatted(fractionLength)
                                let formattedHeight = geometry.size.height.formatted(fractionLength)
                                Text("size: \(formattedWidth), \(formattedHeight)")
                            } else if traits.containsCase(.width) {
                                let formattedWidth = geometry.size.width.formatted(fractionLength)
                                Text("width: \(formattedWidth)")
                            } else if traits.containsCase(.height) {
                                let formattedHeight = geometry.size.height.formatted(fractionLength)
                                Text("height: \(formattedHeight)")
                            }
                        } // Group
                        .foregroundStyle(.secondary)
                        .font(.caption.monospaced())

                    } // VStack
                    .padding(.all, padding)
                    .fixedSize()
                } // FloatingAlignedContainer
            } // GeometryReader
        } // overlay
    }

}


// MARK: - Trait


extension FloatingCaptionModifier {

    enum Trait: CaseIdentifiable {
        case border
        case width
        case height
        case alignment(FloatingAlignment)
        case padding(CGFloat? = nil)

        enum Case {
            case border, width, height, alignment, padding
        }

        var `case`: Case {
            switch self {
            case .border:    .border
            case .width:     .width
            case .height:    .height
            case .alignment: .alignment
            case .padding:   .padding
            }
        }

    }

}


extension BidirectionalCollection where Element == FloatingCaptionModifier.Trait {

    var alignment: FloatingAlignment? {
        let caseInstance = lastCase(.alignment)
        if case .alignment(let alignment) = caseInstance {
            return alignment
        }
        return nil
    }


    var padding: CGFloat? {
        let caseInstance = lastCase(.padding)
        if case .padding(let alignment) = caseInstance {
            return alignment
        }
        return nil
    }

}


extension View {

    func floatingCaption(_ key: LocalizedStringKey, _ traits: FloatingCaptionModifier.Trait...) -> some View {
        modifier(FloatingCaptionModifier(localizedKey: key, traits: traits))
    }

}


// MARK: - Experimental CaseIdentifiable


nonisolated
protocol CaseIdentifiable {
    associatedtype Case: Hashable
    var `case`: Case { get }
}


extension Sequence where Element: CaseIdentifiable {

    func containsCase(_ case: Element.Case) -> Bool {
        contains { $0.case == `case` }
    }

    func firstCase(_ case: Element.Case) -> Element? {
        first { $0.case == `case` }
    }

}

extension BidirectionalCollection where Element: CaseIdentifiable {

    func lastCase(_ case: Element.Case) -> Element? {
        last { $0.case == `case` }
    }

}



// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


#Preview("Default", traits: PreviewContent.layout) {
    Rectangle()
        .fill(.indigo.tertiary)
        .frame(width: 40, height: 100)
        .floatingCaption("Tall Rectangle", .height)

    Rectangle()
        .fill(.indigo.tertiary)
        .frame(width: 200, height: 15)
        .floatingCaption("Short Rectangle", .width, .border)

    Rectangle()
        .fill(.indigo.tertiary)
        .frame(width: 200, height: 100)
        .floatingCaption("Default Padding\n(no trait)", .alignment(.innerLeading))
        .floatingCaption("Zero Padding", .alignment(.innerTrailing), .padding(.zero))
        .floatingCaption("10 Padding", .alignment(.innerBottomLeading), .padding(10))
        .floatingCaption("System Padding", .alignment(.innerBottomTrailing), .padding())
        .floatingCaption("External", .alignment(.outerBottom), .width, .height)
}


#Preview("Alignments", traits: PreviewContent.layout) {
    Rectangle()
    .fill(.indigo.tertiary)
    .frame(square: 200)
    .overlay {
        ForEach(FloatingAlignment.allCases) { alignment in
            ClearRectangle()
            .floatingCaption("aligned\n\(alignment.abbreviatedName)", .alignment(alignment))
        }
    }

}
