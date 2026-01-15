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
                        let textStyle: any ShapeStyle = traits.captionStyle
                            ?? .secondary
                        Text(localizedKey)
                            .foregroundStyle(textStyle)
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
                                    .foregroundStyle(textStyle)
                            } else if traits.containsCase(.width) {
                                let formattedWidth = geometry.size.width.formatted(fractionLength)
                                Text("width: \(formattedWidth)")
                                    .foregroundStyle(textStyle)
                            } else if traits.containsCase(.height) {
                                let formattedHeight = geometry.size.height.formatted(fractionLength)
                                Text("height: \(formattedHeight)")
                                    .foregroundStyle(textStyle)
                            }
                        } // Group
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

    // This trait implementation is an experimental configuration object solely based on an
    // enumeration, in contrast with a structure containing all properties like
    // `DebugOverlayModifier.Configuration`.
    enum Trait: CaseIdentifiable {
        case border
        case width
        case height
        case captionStyle(any ShapeStyle)
        case alignment(FloatingAlignment)
        case padding(CGFloat? = nil)

        enum Case {
            case border, width, height
            case captionStyle, alignment, padding
        }

        // Since the enum have associated values, each enum needs to be indentified by a value-less
        // parallel enum.
        var `case`: Case {
            switch self {
            case .border:       .border
            case .width:        .width
            case .height:       .height
            case .captionStyle: .captionStyle
            case .alignment:    .alignment
            case .padding:      .padding
            }
        }


        static let zeroPadding:    Self = .padding(.zero)
        static let systemPadding: Self = .padding(nil)

    }

}


// For case with an associated value, there needs to be a helper function to extract the last
// value of that case. This means that traits of a given type cannot be additive or build on top
// of each other.
extension BidirectionalCollection where Element == FloatingCaptionModifier.Trait {

    var captionStyle: (any ShapeStyle)? {
        let caseInstance = lastCase(.captionStyle)
        if case .captionStyle(let captionStyle) = caseInstance {
            return captionStyle
        }
        return nil
    }


    var alignment: FloatingAlignment? {
        let caseInstance = lastCase(.alignment)
        if case .alignment(let alignment) = caseInstance {
            return alignment
        }
        return nil
    }


    var padding: CGFloat? {
        let caseInstance = lastCase(.padding)
        if case .padding(let padding) = caseInstance {
            return padding
        }
        return nil
    }

}


extension View {

    func floatingCaption(_ key: LocalizedStringKey, _ traits: FloatingCaptionModifier.Trait...) -> some View {
        modifier(FloatingCaptionModifier(localizedKey: key, traits: traits))
    }


    func floatingCaption(_ key: LocalizedStringKey, traits: [FloatingCaptionModifier.Trait]) -> some View {
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
        .fill(.indigo.gradient.tertiary)
        .frame(width: 40, height: 100)
        .floatingCaption("Tall Rectangle", .height)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(width: 200, height: 15)
        .floatingCaption("Short Rectangle", .width, .border)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(width: 200, height: 100)
        .floatingCaption("Default Padding\n(no trait)", .alignment(.innerLeading))
        .floatingCaption("Zero Padding",   .alignment(.innerTrailing),       .zeroPadding)
        .floatingCaption("10 Padding",     .alignment(.innerBottomLeading),  .padding(10))
        .floatingCaption("System Padding", .alignment(.innerBottomTrailing), .systemPadding)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(square: 100)
        .floatingCaption(
            "External", .captionStyle(.indigo.secondary),
            .width, .height, .alignment(.outerBottom))
}


#Preview("Alignments", traits: PreviewContent.layout) {
    Rectangle()
    .fill(.indigo.gradient.tertiary)
    .frame(square: 200)
    .overlay {
        ForEach(FloatingAlignment.allCases) { alignment in
            ClearRectangle()
            .floatingCaption("aligned\n\(alignment.abbreviatedName)", .alignment(alignment))
        }
    }

}
