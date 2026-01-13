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
                FloatingAlignedContainer(alignment: alignment) { alignment, textAlignment in
                    VStack(alignment: alignment.horizontal, spacing: .zero) {
                        Text(localizedKey)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .multilineTextAlignment(textAlignment)

                        if traits.containsCase(.height) {
                            Text("height: \(geometry.size.height, format: .fractionLength(2))")
                                .foregroundStyle(.secondary)
                                .font(.caption.monospaced())
                        }
                    } // VStack
                    .padding(2)
                    .fixedSize()
                } // FloatingAlignedContainer
            } // GeometryReader
        } // overlay
    }

}


extension FloatingCaptionModifier {

    enum Trait: CaseIdentifiable {
        case border
        case height
        case alignment(FloatingAlignment)

        enum Case {
            case border, height, alignment
        }

        var `case`: Case {
            switch self {
            case .border: .border
            case .height: .height
            case .alignment: .alignment
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
        .frame(width: 40, height: 200)
        .floatingCaption("Tall Rectangle", .height)

    Rectangle()
        .fill(.indigo.tertiary)
        .frame(width: 200, height: 15)
        .floatingCaption("Short Rectangle", .height, .border)
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
