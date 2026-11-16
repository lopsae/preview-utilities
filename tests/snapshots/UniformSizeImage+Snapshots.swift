//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct UniformSizeImageSnapshots {

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

                let fonts: KeyValuePairs<String, Font> = [
                    "Caption": .caption,
                    "Body":    .body,
                    "Title":   .title,
                ]
                ForEach(fonts, id: \.key) { key, font in
                    UniformSizeSymbol(systemName: "circle")
                    .font(font)
                    .floatingCaption(verbatim: key, alignment: .outerTrailing, .colorStyle(.teal), .size)
                }
            }
            .padding(.horizontal, 20)
        }

        Snapshots.assertView("imageScales") {
            VStack.expandingWidth(alignment: .leading, spacing: 20) {
                UniformSizeSymbol(systemName: "circle")
                .floatingCaption("Default", alignment: .outerTrailing, .colorStyle(.teal), .size)

                let scales: KeyValuePairs<String, Image.Scale> = [
                    "Small":  .small,
                    "Medium": .medium,
                    "Large":  .large,
                ]
                ForEach(scales, id: \.key) { key, scale in
                    UniformSizeSymbol(systemName: "circle")
                    .imageScale(scale)
                    .floatingCaption(verbatim: key, alignment: .outerTrailing, .colorStyle(.teal), .size)
                }
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


    @Test func alignment() {
        let images: KeyValuePairs<Font, String> = [
            .caption2: "ladybug",
            .caption:  "guidepoint.horizontal",
            .footnote: "guidepoint.vertical",
            .body:     "photo.badge.shield.exclamationmark",
            .title2:   "clock.badge.airplane",
            .title:    "circle",
        ]

        let alignments: KeyValuePairs<String, VerticalAlignment> = [
            "firstTextBaseline": .firstTextBaseline,
            "top": .top, "bottom": .bottom
        ]

        for (key, alignment) in alignments {
            Snapshots.assertView(key, spacing: 20) {
                HStack(images, id: \.key, alignment: alignment, spacing: 8) { font, imageName in
                    UniformSizeSymbol(systemName: imageName)
                }
                .debugAlignmentGuide(vertical: alignment)

                HStack(images, id: \.key, alignment: alignment, spacing: 8) { font, imageName in
                    UniformSizeSymbol(systemName: imageName)
                    .font(font)
                }
                .debugAlignmentGuide(vertical: alignment)

                DashedDivider()

                HStack(images, id: \.key, alignment: alignment, spacing: 8) { font, imageName in
                    Image(systemName: imageName)
                }
                .debugAlignmentGuide(vertical: alignment)
            }
        }
    }


    @Test func sizes() {
        let imageNames: [String] = [
            "ladybug",
            "guidepoint.horizontal",
            "guidepoint.vertical",
            "photo.badge.shield.exclamationmark",
            "clock.badge.airplane",
            "circle",
        ]

        func sizeComparisonStack(imageNames: some RandomAccessCollection<String>, font: Font) -> some View {
            HStack(items: imageNames, alignment: .firstTextBaseline, spacing: 8) { imageName in
                UniformSizeSymbol {
                    Image(systemName: imageName)
                    .background(.orange.secondary)
                }
                .border(.teal.secondary, width: 2)
            }
            .debugAlignmentGuide(vertical: .firstTextBaseline)
            .font(font)
        }

        Snapshots.assertView("comparison", spacing: 20) {
            ForEach([Font.caption, .body], id: \.self) { font in
                sizeComparisonStack(imageNames: imageNames, font: font)
            }

            // Images with Title font, list is split in half.
            ForEach(imageNames.splitting().enumerated(), id: \.offset) { offset, halfImageNames in
                sizeComparisonStack(imageNames: halfImageNames, font: .title)
            }
        }
    }

}


extension RandomAccessCollection {

    // FIXME: Update function to split into any number of splits.
    func splitting(/*into: Int*/) -> [SubSequence] {
        let halfDistance: Int = ceil(count.asDouble / 2.0).asInt
        let halfIndex: Index = self.index(startOffsetBy: halfDistance)
        return [
            self[self.startIndex..<halfIndex],
            self[halfIndex...]
        ]
    }

}
