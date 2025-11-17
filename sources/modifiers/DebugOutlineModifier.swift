//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Adds a debug overlay that draws a dashed stroke inset in the views border, and a solid stroke
/// outset of the view border.
public struct DebugOutlineModifier: ViewModifier {

    let lineWidth: CGFloat
    let options: Options


    init(lineWidth: CGFloat = 5, options: Options = []) {
        self.lineWidth = lineWidth
        self.options = options
    }


    public func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            GeometryReader { geometry in
                // Outer Stroke
                Rectangle()
                    .stroke(.blue.tertiary, lineWidth: lineWidth * 2)
                    .mask {
                        Path { path in
                            let frame = geometry.frame(in: .local)
                            path.addRect(frame.inset(by: -lineWidth))
                            path.addRect(frame)
                        }
                        .fill(style: .init(eoFill: true))
                    }

                // Inner Stroke
                Rectangle()
                    .strokeBorder(.red.tertiary, style: innerStrokeStyle)

                // Geometry Info
                geometryInfoView(geometry)
            } // GeometryReader
            .allowsHitTesting(false)
        } // overlay
    }


    private var innerStrokeStyle: StrokeStyle {
        .init(
            lineWidth: lineWidth,
            dash: [lineWidth * 3, lineWidth * 2]
        )
    }


    @ViewBuilder
    private func geometryInfoView(_ geometry: GeometryProxy) -> some View {
        if !options.isEmpty {
            let stackOffset = options.contains(.infoOutside)
                ? geometry.size.height
                : 0

            VStack(alignment: .leading, spacing: 2) {
                let globalFrame = geometry.frame(in: .global)
                let floatFormat: FloatingPointFormatStyle<Float> = .number.precision(.fractionLength(2))

                if options.contains(.size) {
                    let formattedWidth = globalFrame.width.toFloat.formatted(floatFormat)
                    let formattedHeight = globalFrame.height.toFloat.formatted(floatFormat)
                    Text("size: \(formattedWidth), \(formattedHeight)")
                }
                
                if options.contains(.origin) {
                    let formattedX = globalFrame.origin.x.toFloat.formatted(floatFormat)
                    let formattedY = globalFrame.origin.y.toFloat.formatted(floatFormat)
                    Text("orig: \(formattedX), \(formattedY)")
                }
                
                if options.contains(.safeAreaInsets) {
                    Text("safeInsets:\n\(geometry.safeAreaInsets, format: .previewPrintout)")
                }
            } // VStack
            .font(.caption)
            .monospaced()
            .foregroundStyle(.secondary)
            .padding([.top, .leading], lineWidth * 1.5)
            .fixedSize()
            .offset(y: stackOffset)
        }
    }

}


extension DebugOutlineModifier {

    @MainActor
    public struct Options: @MainActor OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let size: Self =           .init(shiftedBy: 0)
        static let origin: Self =         .init(shiftedBy: 1)
        static let safeAreaInsets: Self = .init(shiftedBy: 2)
        static let infoOutside: Self =    .init(shiftedBy: 3)

        static let allGeometry: Self = [.size, .origin, .safeAreaInsets]
    }

}


extension View {

    /// Adds a debug outline overlay to the view.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the debug outline strokes. Default is 5.
    ///   - options: Options to enable display of additional information, and other display configurations.
    ///
    /// - Returns: The calling view with an overlay highlighing its frame, and additional information when enabled.
    ///
    /// Example usage:
    /// ```swift
    /// // Only outlines.
    /// Text("Hello")
    ///     .debugOutline()
    ///
    /// // Outlines along size and origin info
    /// Text("Hello")
    ///     .debugOutline(options: .size, .origin)
    /// ```
    public func debugOutline(
        lineWidth: CGFloat = 5,
        options: DebugOutlineModifier.Options...
    ) -> some View {
        modifier(DebugOutlineModifier(lineWidth: lineWidth, options: options.union()))
    }

}


// MARK: - EdgeInsetPreviewFormatStyle


struct EdgeInsetPreviewFormatStyle: FormatStyle {

    func format(_ value: EdgeInsets) -> String {
        let floatFormat: FloatingPointFormatStyle<Float> = .number.precision(.fractionLength(2))
        let formattedTop = value.top.toFloat.formatted(floatFormat)
        let formattedLeading = value.leading.toFloat.formatted(floatFormat)
        let formattedBottom  = value.bottom.toFloat.formatted(floatFormat)
        let formattedTrailing = value.trailing.toFloat.formatted(floatFormat)
        return "t:\(formattedTop), l:\(formattedLeading),\nb:\(formattedBottom), r:\(formattedTrailing)"
    }

}


extension FormatStyle where Self == EdgeInsetPreviewFormatStyle {
    internal static var previewPrintout: EdgeInsetPreviewFormatStyle {
        EdgeInsetPreviewFormatStyle()
    }
}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    StarShape(points: 5, concaveVertexRatio: 0.5)
        .fill(.pink)
        .debugOutline()
}


#Preview("All geometry", traits: .headerFooter) {
    StarShape(points: 5, concaveVertexRatio: 0.5)
        .fill(.pink)
        .debugOutline(options: .allGeometry)
}


#Preview("Size only", traits: .headerFooter) {
    StarShape(points: 5, concaveVertexRatio: 0.5)
        .fill(.pink)
        .debugOutline(options: .size)
}


#Preview("Size and origin", traits: .headerFooter) {
    StarShape(points: 5, concaveVertexRatio: 0.5)
        .fill(.pink)
        .debugOutline(options: .size, .origin)
}


#Preview("Info outside", traits: .headerFooter) {
    StarShape(points: 5, concaveVertexRatio: 0.5)
        .fill(.pink)
        .debugOutline(options: .allGeometry, .infoOutside)
}


#Preview("Interactive", traits: .headerFooter) {
    @Previewable @State var counter: Int = 0
    ZStack(alignment: .topLeading) {
        StarShape(points: 5, concaveVertexRatio: 0.5)
            .fill(.pink)
        Button("Increment", systemImage: "ladybug") {
            counter += 1
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    .debugOutline(options: .allGeometry)
    Text("Counter: \(counter)")
        .monospaced()
        .padding()
}


// To preview content where the outline is smaller that the geometry information displayed.
#Preview("Small content", traits: .headerFooter) {
    Text("Preview text")
        .monospaced()
        .debugOutline(options: .allGeometry)
}


#Preview("Small content with info outside", traits: .headerFooter) {
    Text("Preview text")
        .monospaced()
        .debugOutline(options: .allGeometry, .infoOutside)
}


// MARK: - Examples of edge cases


// Overlay allows its content to overflow around the owner view, without modifying the owner
// position or size.
#Preview("Example: .overlay", traits: .headerFooter) {

    Rectangle()
        .strokeBorder(.red, lineWidth: 10)
        .frame(square: 50)
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
            }.fixedSize()
        }
        .border(.orange, width: 4)
}


// ZStack of the same elements, where the ZStack grows to accomodate the size of all contained
// elements.
#Preview("Example: ZStack", traits: .headerFooter) {

    ZStack(alignment: .topLeading) {
        Rectangle()
            .strokeBorder(.red, lineWidth: 10)
            .frame(square: 50)
        VStack(alignment: .leading) {
            Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
        }.fixedSize()
    }
    .border(.orange, width: 4)

}
