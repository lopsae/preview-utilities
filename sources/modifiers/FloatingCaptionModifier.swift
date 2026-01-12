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
        content.overlay {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    VStack(spacing: .zero) {
                        Text(localizedKey)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .fixedSize()
                        if traits.contains(.height) {
                            Text("height: \(geometry.size.height, format: .fractionLength(2))")
                                .foregroundStyle(.secondary)
                                .font(.caption.monospaced())
                                .fixedSize()
                        }
                    } // VStack
                } // ZStack
                .frame(size: geometry.size, alignment: .center)
                .border(.quaternary, width: traits.contains(.border) ? 1 : .zero)
            } // GeometryReader
        } // overlay
    }

}


extension FloatingCaptionModifier {

    enum Trait {
        case border
        case height
    }

}


extension View {

    func floatingCaption(_ key: LocalizedStringKey, _ traits: FloatingCaptionModifier.Trait...) -> some View {
        modifier(FloatingCaptionModifier(localizedKey: key, traits: traits))
    }

}


// MARK: - Previews


#Preview("Default", traits: .iPhoneProSizeLayout) {
    Rectangle()
        .fill(.purple.tertiary)
        .frame(width: 40, height: 200)
        .floatingCaption("Tall Rectangle", .height)

    Rectangle()
        .fill(.indigo.tertiary)
        .frame(width: 200, height: 10)
        .floatingCaption("Short Rectangle", .height, .border)
}
