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

    // FIXME: Test styles.
    // FIXME: Test sizes of circle at different fonts.
    // FIXME: Test sizes.
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


    /// In Snapshots, the circle does not have a square size, seems some padding is added width-wise.
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


//    @Test func uniformSize() {
//        Snapshots.assertView("fonts") {
//            VStack.expandingWidth(alignment: .leading, spacing: 16) {
//                UniformSizeSymbol(systemName: "circle")
//                .floatingCaption("Default", alignment: .outerTrailing, .colorStyle(.teal), .size)
//
//                let fonts: [(label: String, font: Font)] = [
//                    ("Caption", .caption),
//                    ("Body", .body),
//                    ("Headline", .headline),
//                    ("Title", .title),
//                ]
//                ForEach(fonts, id: \.label) { label, font in
//                    UniformSizeSymbol(systemName: "circle")
//                    .font(font)
//                    .floatingCaption(verbatim: label, alignment: .outerTrailing, .colorStyle(.teal), .size)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//
//        Snapshots.assertView("imageScales", spacing: 20) {
//            UniformSizeSymbol(systemName: "circle")
//            .imageScale(.small)
//            .floatingCaption("Caption", alignment: .outerTrailing, .colorStyle(.teal), .size)
//
//            UniformSizeSymbol(systemName: "circle")
//            .floatingCaption("Default", alignment: .outerTrailing, .colorStyle(.teal), .size)
//
//            UniformSizeSymbol(systemName: "circle")
//            .imageScale(.medium)
//            .floatingCaption("Medium", alignment: .outerTrailing, .colorStyle(.teal), .size)
//
//            UniformSizeSymbol(systemName: "circle")
//            .font(.title)
//            .floatingCaption("Large", alignment: .outerTrailing, .colorStyle(.teal), .size)
//        }
//    }

}
