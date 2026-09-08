//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing
import SnapshotTesting


// TODO: Test debug bounds with highlight.
// TODO: Test highlight at start, middle, end.

@MainActor
struct HighlightTextRendererSnapshots {

    @Test(.snapshotTesting) func lineRendering() {
        let renderer = HighlightTextRenderer { context, runs, bounds, leadingStart, trailingEnd in
            bounds.stroke(in: context, style: .orange, lineWidth: 2, alignment: .inner)

            let leadingColor: Color = leadingStart ? .green : .red
            bounds.leadingSegment
            .stroke(in: context, style: leadingColor, lineWidth: 4, alignment: .inner)

            let trailingColor: Color = trailingEnd ? .green : .red
            bounds.trailingSegment
                .stroke(in: context, style: trailingColor, lineWidth: 4, alignment: .inner)

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


    @Test(.snapshotTesting) func debugRendering() {
        let drawHighlight: HighlightTextRenderer.DrawHighlight = { context, runs, bounds, leadingStart, trailingEnd in
            bounds.outset(by: 2).stroke(in: context, style: .orange.tertiary, lineWidth: 2, alignment: .outer)
            context.draw(runs: runs)
        }

        Snapshots.assertView("options", colorSchemes: .all) {
            let highlight = Text("Highlight").customAttribute(HighlightTextRenderer.Highlight())
            VStack(spacing: Defaults.padding) {
                Text("All \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .all, drawHighlight: drawHighlight))

                Text("Rect \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .onlyRect, drawHighlight: drawHighlight))

                Text("None \(highlight) Debug")
                .expandingWidthFrame(textAlignment: .center)
                .textRenderer(HighlightTextRenderer(debugRuns: .none, drawHighlight: drawHighlight))
            }
            .padding()
        }
    }


    @Test(.snapshotTesting) func dashedCapsule() {
        Snapshots.assertView("default", colorSchemes: .all) {
            VStack(spacing: Defaults.padding) {
                Text("Default \(highlight: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Label \(highlight: "ladybug", label: "Label", style: .orange)")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Capsule \(highlight: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule(style: .orange))
            }
        }

        Snapshots.assertView("foregroundStyle", colorSchemes: .all) {
            VStack(spacing: Defaults.padding) {
                Text("Default \(highlight: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Label \(highlight: "ladybug", label: "Label", style: .orange)")
                .textRenderer(HighlightTextRenderer.dashedCapsule())

                Text("Capsule \(highlight: "ladybug", label: "Label")")
                .textRenderer(HighlightTextRenderer.dashedCapsule(style: .orange))
            }
            .foregroundStyle(.indigo)
        }
    }


    @Test(.snapshotTesting) func dashedCapsuleLines() {
        let renderer = HighlightTextRenderer.dashedCapsule(style: .orange)

        Snapshots.assertView("singleLine") {
            Text("Single line \(highlight: "pencil.line", label: "highlight")")
            .textRenderer(renderer)
            .padding()
        }

        Snapshots.assertView("splitLine") {
            Text("Split line \(highlight: "pencil.line", label: "longer highlight", breaking: true) text")
            .textRenderer(renderer)
            .padding()
        }

        Snapshots.assertView("multiLine") {
            let longString = "longer highlight that spans through three"
            Text("Multiple line \(highlight: "pencil.line", label: longString, breaking: true) lines")
            .textRenderer(renderer)
            .padding()
        }
    }

}
