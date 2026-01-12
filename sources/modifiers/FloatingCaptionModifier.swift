//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension View {

    /// Experimental labeling for interactive preview elements, specially rectangles.
    func floatingCaption(_ key: LocalizedStringKey, _ options: PreviewCaptionOptions...) -> some View {
        self.overlay {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    VStack(spacing: .zero) {
                        Text(key)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .fixedSize()
                        if options.contains(.height) {
                            Text("height: \(geometry.size.height, format: .fractionLength(2))")
                                .foregroundStyle(.secondary)
                                .font(.caption.monospaced())
                                .fixedSize()
                        }
                    } // VStack
                } // ZStack
                .frame(size: geometry.size, alignment: .center)
                .border(.quaternary, width: options.contains(.border) ? 1 : .zero)
            } // GeometryReader
        } // Overlay
    }

}


enum PreviewCaptionOptions {
    case border
    case height
}
