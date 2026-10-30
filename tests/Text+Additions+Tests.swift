//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct TextLayoutAdditionsTests {

    struct Marker: TextAttribute {}


    /// Stores the layout captured by `CaptureRenderer`.
    final class LayoutBox {
        var layout: Text.Layout?
    }


    /// Captures the received layout, then draws normally.
    struct CaptureRenderer: TextRenderer {
        let box: LayoutBox

        func draw(layout: Text.Layout, in context: inout GraphicsContext) {
            box.layout = layout
            for line in layout { context.draw(line) }
        }
    }


    /// Produces a `Text.Layout` for `text` by rendering it offscreen with a capturing renderer.
    ///
    /// `Text.Layout` has no public initializer, it is only available through
    /// `TextRenderer.draw(layout:in:)`, which `ImageRenderer` triggers synchronously.
    static func captureLayout(of text: Text, width: CGFloat? = nil) -> Text.Layout? {
        let box = LayoutBox()
        let view = text
            .textRenderer(CaptureRenderer(box: box))
            .frame(width: width)
        _ = ImageRenderer(content: view).cgImage
        return box.layout
    }


    /// Returns the substring of `source` that `run` draws.
    ///
    /// Depends on `CharacterIndex` matching UTF-16 offsets in `source`, which holds in
    /// practice but isn't documented. Use plain ASCII, non-localized sources in tests.
    static func string(of run: Text.Layout.Run, in layout: Text.Layout, source: String) -> String? {
        guard
            let origin = layout.first?.first?.characterIndices.first,
            let lower = run.characterIndices.min(),
            let upper = run.characterIndices.max()
        else { return nil }

        let utf16 = source.utf16
        let start = utf16.index(utf16.startIndex, offsetBy: origin.distance(to: lower))
        let end = utf16.index(utf16.startIndex, offsetBy: origin.distance(to: upper) + 1)
        return String(source[start..<end])
    }


    @Test func runs() throws {
        let marked = Text("marked").customAttribute(Marker())
        let text = Text("Hello \(marked) world")
        let layout = try #require(Self.captureLayout(of: text, width: 80))

        #expect(layout.count == 3)
        #expect(layout.runs.count == 4)

        let strings = layout.runs.compactMap { run in
            Self.string(of: run, in: layout, source: "Hello marked world")
        }
        #expect(strings == ["Hello ", "marked", " ", "world"])
    }


    @Test func attributedRuns() throws {
        let marked = Text("marked").customAttribute(Marker())
        let text = Text("Hello \(marked) world")
        let layout = try #require(Self.captureLayout(of: text))

        let attributedRuns = layout.attributedRuns(with: Marker.self)
        #expect(attributedRuns.count == 1)

        let strings = attributedRuns.compactMap { run, _ in
            Self.string(of: run, in: layout, source: "Hello marked world")
        }
        #expect(strings == ["marked"])
    }


    @Test func attributedRunsWithoutAttribute() throws {
        let layout = try #require(Self.captureLayout(of: Text("Hello world")))

        #expect(layout.runs.isEmpty == false)
        #expect(layout.attributedRuns(with: Marker.self).isEmpty)
    }

}
