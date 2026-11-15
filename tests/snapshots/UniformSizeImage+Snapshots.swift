//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct UniformSizeImageSnapshots {

    // FIXME: Test sizes of image vs size of layout.
    // FIXME: Test alignment.

    @Test func inits() {
        Snapshots.assertView("all", spacing: 20, colorSchemes: .all) {
            UniformSizeSymbol(systemName: "ladybug")

            UniformSizeSymbol {
                Image(systemName: "ladybug")
                .background(.orange.secondary)
            }

            UniformSizeSymbol(content: Image(systemName: "ladybug").background(.yellow.secondary))
            .border(.teal.secondary, width: 2)
        }
    }


    /// In Snapshots, the circle does not have a perfect square size, while in previews it does.
    @Test func circleSize() {
        Snapshots.assertView("check") {
            VStack.expandingWidth(alignment: .leading, spacing: 20) {
                Image(systemName: "circle")
                .floatingCaption("Image", alignment: .outerTrailing, .colorStyle(.teal), .size)

                UniformSizeSymbol(systemName: "circle")
                .floatingCaption("UniformSizeSymbol", alignment: .outerTrailing, .colorStyle(.teal), .size)
            }
            .padding(.horizontal, 20)
        }
    }


    @Test func uniformSize() {
        Snapshots.assertView("fonts") {
            VStack.expandingWidth(alignment: .leading, spacing: 20) {
                UniformSizeSymbol(systemName: "circle")
                .floatingCaption("Default", alignment: .outerTrailing, .colorStyle(.teal), .size)

                let fonts: [(label: String, font: Font)] = [
                    ("Caption",  .caption),
                    ("Body",     .body),
                    ("Title",    .title),
                ]
                ForEach(fonts, id: \.label) { label, font in
                    UniformSizeSymbol(systemName: "circle")
                    .font(font)
                    .floatingCaption(verbatim: label, alignment: .outerTrailing, .colorStyle(.teal), .size)
                }
            }
            .padding(.horizontal, 20)
        }

        Snapshots.assertView("imageScales") {
            // FIXME: Dry like above.
            VStack.expandingWidth(alignment: .leading, spacing: 20) {
                UniformSizeSymbol(systemName: "circle")
                .floatingCaption("Default", alignment: .outerTrailing, .colorStyle(.teal), .size)

                UniformSizeSymbol(systemName: "circle")
                .imageScale(.small)
                .floatingCaption("Small", alignment: .outerTrailing, .colorStyle(.teal), .size)

                UniformSizeSymbol(systemName: "circle")
                .imageScale(.medium)
                .floatingCaption("Medium", alignment: .outerTrailing, .colorStyle(.teal), .size)

                UniformSizeSymbol(systemName: "circle")
                .font(.title)
                .floatingCaption("Large", alignment: .outerTrailing, .colorStyle(.teal), .size)
            }
            .padding(.horizontal, 20)
        }
    }


    @Test func styles() {
        Snapshots.assertView("foreground", colorSchemes: .all) {
            VStack(alignment: .leading, spacing: 20) {
                let styles: [(label: String, style: AnyShapeStyle)] = [
                    ("Red",       AnyShapeStyle(.red)),
                    ("Teal",      AnyShapeStyle(.teal)),
                    ("Primary",   AnyShapeStyle(.primary)),
                    ("Secondary", AnyShapeStyle(.secondary)),
                ]
                ForEach(styles, id: \.label) { label, style in
                    HStack(alignment: .firstTextBaseline) {
                        UniformSizeSymbol(systemName: "ladybug")
                        .foregroundStyle(style)
                        Text(label)
                    }
                }
            }
        }
    }

}
