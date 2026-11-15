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


    @Test func alignment() {
        // FIXME: Use dictionary instead.
        let images: [(font: Font, imageName: String)] = [
            (.caption2, "ladybug"),
            (.caption,  "guidepoint.horizontal"),
            (.footnote, "guidepoint.vertical"),
            (.body,     "photo.badge.shield.exclamationmark"),
            (.title2,   "clock.badge.airplane"),
            (.title,    "circle"),
        ]

        let alignments: [String: VerticalAlignment] = [
            "firstTextBaseline": .firstTextBaseline,
            "top": .top, "bottom": .bottom
        ]

        for (key, alignment) in alignments {
            Snapshots.assertView(key, spacing: 20) {
                HStack(images, id: \.imageName, alignment: alignment, spacing: 8) { font, imageName in
                    UniformSizeSymbol(systemName: imageName)
                }
                .debugAlignmentGuide(vertical: alignment)

                HStack(images, id: \.imageName, alignment: alignment, spacing: 8) { font, imageName in
                    UniformSizeSymbol(systemName: imageName)
                    .font(font)
                }
                .debugAlignmentGuide(vertical: alignment)

                DashedDivider()

                HStack(images, id: \.imageName, alignment: alignment, spacing: 8) { font, imageName in
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

        // FIXME: Dry with a local function.

        Snapshots.assertView("comparison", spacing: 20) {
            ForEach([Font.caption, .body], id: \.self) { font in
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

            ForEach(imageNames.splitting().enumerated(), id: \.offset) { offset, halfImageNames in
                HStack(items: halfImageNames, alignment: .firstTextBaseline, spacing: 8) { imageName in
                    UniformSizeSymbol {
                        Image(systemName: imageName)
                        .background(.orange.secondary)
                    }
                    .border(.teal.secondary, width: 2)
                }
                .debugAlignmentGuide(vertical: .firstTextBaseline)
                .font(.title)
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
