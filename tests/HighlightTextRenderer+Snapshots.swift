//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


// FIXME: See if this could be tested without @testable, might require publicizing of Segment.
@testable import PreviewUtilities

import SwiftUI
import Testing
import SnapshotTesting


// TODO: Test debug bounds with highlight.
// TODO: Test highlight at start, middle, end.

@MainActor
struct HighlightTextRendererSnapshots {

    @Test(.snapshotCapture) func lineRendering() {
        let renderer = HighlightTextRenderer { context, runs, bounds, leadingStart, trailingEnd in
            // FIXME: add parameter to stroke for inset behaviour.
            bounds.stroke(in: context, style: .orange, lineWidth: 2)

            // FIXME: Could an InsettableSegment contain information to inset itself? So that it could be properly drawn at edge of bounds.
            bounds.leadingSegment
                .stroke(in: context, style: leadingStart ? .green : .red, lineWidth: 4)
            bounds.trailingSegment
                .stroke(in: context, style: trailingEnd ? .green : .red, lineWidth: 4)

            context.draw(runs: runs)
        }

        Snapshots.assertView("singleLine") {
            let highlight = Text("highlight").customAttribute(HighlightTextRenderer.Highlight())
            Text("Single line \(highlight)")
            .textRenderer(renderer)
            .padding()
        }

        Snapshots.assertView("splitLine") {
            let highlight = Text("longer highlight").customAttribute(HighlightTextRenderer.Highlight())
            Text("Split line \(highlight) text")
            .textRenderer(renderer)
            .padding()
        }

        Snapshots.assertView("multiLine") {
            let highlight = Text("longer highlight that spans through three")
            .customAttribute(HighlightTextRenderer.Highlight())
            Text("Multiple line \(highlight) lines")
            .textRenderer(renderer)
            .padding()
        }

        Snapshots.assertView("positions") {
            let highlight = Text("Highlight").customAttribute(HighlightTextRenderer.Highlight())
            VStack(spacing: Defaults.padding) {
                Text("\(highlight) Middle End")
                Text("Start \(highlight) End")
                Text("Start Middle \(highlight)")

            }
            .padding()
            .textRenderer(renderer)
        }
    }


    @Test(.snapshotCapture) func debugRendering() {
        let drawHighlight: HighlightTextRenderer.DrawHighlight = { context, runs, bounds, leadingStart, trailingEnd in
            bounds.stroke(in: context, style: .orange, lineWidth: 2)
            context.draw(runs: runs)
        }

        Snapshots.assertView("options", colorSchemes: .all) {
            let highlight = Text("Highlight").customAttribute(HighlightTextRenderer.Highlight())
            VStack(spacing: Defaults.padding) {
                Text("All \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .all, drawHighlights: drawHighlight))

                // FIXME: onlyRects not displaying properly.
                Text("Rect \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .onlyRect, drawHighlights: drawHighlight))

                Text("None \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .none, drawHighlights: drawHighlight))
            }
            .padding()
        }
    }


    @Test(.snapshotCapture) func dashedCapsule() {
        Snapshots.assertView("default", colorSchemes: .all) {
            VStack(spacing: Defaults.padding) {
                Text("Default \(capsule: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Label \(capsule: "ladybug", label: "Label", style: .orange)")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Capsule \(capsule: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule(style: .orange))
            }
        }

        Snapshots.assertView("foregroundStyle", colorSchemes: .all) {
            VStack(spacing: Defaults.padding) {
                Text("Default \(capsule: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Label \(capsule: "ladybug", label: "Label", style: .orange)")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Capsule \(capsule: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule(style: .orange))
            }
            .foregroundStyle(.indigo)
        }
    }

}


extension GraphicsContext {

    func draw(
        runs: [Text.Layout.Run],
        options: Text.Layout.DrawingOptions = .init()
    ) {
        for run in runs {
            draw(run, options: options)
        }
    }

}
