//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DebugAlignmentGuideModifierSnapshots {

    enum TestContent {
        static let single: some View =
            Text("Ag")
            .font(.title.pointSize(100))

        static let multi: some View =
            Text("Sphinx\nof Black\nQuartz")
            .font(.largeTitle)

        static let square: some View =
            Rectangle()
            .fill(.gray)
            .frame(squareOf: 100)

    }


    @Test func compositeAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all, record: .missing) {
            TestContent.single
            .debugAlignmentGuide(.topLeading)
            .debugAlignmentGuide(.center)
            .debugAlignmentGuide(.bottomTrailing)
        }

        Snapshots.assertView("firstTextBaseline", colorSchemes: .all, record: .missing) {
            TestContent.multi
            .debugAlignmentGuide(.leadingFirstTextBaseline)
        }

        Snapshots.assertView("lastTextBaseline", colorSchemes: .all, record: .missing) {
            TestContent.multi
            .debugAlignmentGuide(.trailingLastTextBaseline)
        }
    }


    @Test func horizontalAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all, record: .missing) {
            TestContent.single
            .debugAlignmentGuide(horizontal: .leading)
            .debugAlignmentGuide(horizontal: .center)
            .debugAlignmentGuide(horizontal: .trailing)
        }
    }


    @Test func verticalAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all, record: .missing) {
            TestContent.multi
            .debugAlignmentGuide(vertical: .top)
            .debugAlignmentGuide(vertical: .firstTextBaseline)
            .debugAlignmentGuide(vertical: .center)
            .debugAlignmentGuide(vertical: .lastTextBaseline)
            .debugAlignmentGuide(vertical: .bottom)
        }
    }

    @Test func alignmentsWithOpacity() {
        Snapshots.assertView("horizontal", record: .missing) {
            TestContent.single
            .debugAlignmentGuide(horizontal: .leading)
            .floatingHorizontalMarker()

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(true))
            .floatingHorizontalMarker()

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(false))
            .floatingHorizontalMarker()

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half))
            .floatingHorizontalMarker()

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .hidden)
            .floatingHorizontalMarker()

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.one))
            .floatingHorizontalMarker()
        }

        Snapshots.assertView("vertical", record: .missing) {
            TestContent.single
            .debugAlignmentGuide(vertical: .top)
            .floatingVerticalMarker()

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(true))
            .floatingVerticalMarker()

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(false))
            .floatingVerticalMarker()

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half))
            .floatingVerticalMarker()

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .hidden)
            .floatingVerticalMarker()

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.one))
            .floatingVerticalMarker()
        }

        Snapshots.assertView("composite", record: .missing) {
            let offset: CGFloat = 20

            TestContent.single
            .debugAlignmentGuide(.topLeading)

            .alignmentGuide(.top, offsetBy: offset)
            .alignmentGuide(.leading, offsetBy: offset)
            .debugAlignmentGuide(.topLeading, .opacity(.half), .visible(true))

            .alignmentGuide(.top, offsetBy: offset)
            .alignmentGuide(.leading, offsetBy: offset)
            .debugAlignmentGuide(.topLeading, .opacity(.half), .visible(false))

            .alignmentGuide(.top, offsetBy: offset)
            .alignmentGuide(.leading, offsetBy: offset)
            .debugAlignmentGuide(.topLeading, .opacity(.half))

            .alignmentGuide(.top, offsetBy: offset)
            .alignmentGuide(.leading, offsetBy: offset)
            .debugAlignmentGuide(.topLeading, .opacity(.half), .hidden)

            .alignmentGuide(.top, offsetBy: offset)
            .alignmentGuide(.leading, offsetBy: offset)
            .debugAlignmentGuide(.topLeading, .opacity(.one))
        }

    }


    @Test func alignmentsWithStyle() {
        Snapshots.assertView("both", colorSchemes: .all, record: .missing) {
            TestContent.single
            .debugAlignmentGuide(horizontal: .center, .style(.green.secondary))
            .debugAlignmentGuide(vertical: .center, .style(.blue.secondary))
        }

        Snapshots.assertView("composite", colorSchemes: .all, record: .missing) {
            TestContent.single
            .debugAlignmentGuide(.center, .style(.green.secondary))
        }

        Snapshots.assertView("compositeBoth", colorSchemes: .all, record: .missing) {
            TestContent.single
            .debugAlignmentGuide(.topLeading, .style(horizontal: .green.secondary, vertical: .blue.secondary))
            .debugAlignmentGuide(.bottomTrailing, .style(horizontal: .orange.secondary, vertical: .purple.secondary))
        }
    }


    @Test func alignmentsWithExtendedLength() {
        Snapshots.assertView("horizontal", record: .missing) {
            TestContent.square
            .debugAlignmentGuide(horizontal: .leading,  .extendLength(50))
            .debugAlignmentGuide(horizontal: .center,   .extendLength(0))
            .debugAlignmentGuide(horizontal: .trailing, .extendLength(-50))
        }

        Snapshots.assertView("vertical", record: .missing) {
            TestContent.square
            .debugAlignmentGuide(vertical: .top,    .extendLength(50))
            .debugAlignmentGuide(vertical: .center, .extendLength(0))
            .debugAlignmentGuide(vertical: .bottom, .extendLength(-50))
        }

        Snapshots.assertView("composite", record: .missing) {
            TestContent.square
            .debugAlignmentGuide(.topLeading,     .length(.extended(50)))
            .debugAlignmentGuide(.center,         .length(.extended(0)))
            .debugAlignmentGuide(.bottomTrailing, .length(.extended(-50)))
        }
    }


    // FIXME: add tests for .anchor trait once the other lengths are implemented

}


private extension View {

    func floatingHorizontalMarker() -> some View {
        // TODO: use floatingContent/FloatingAlignedContainer function when it actually uses alignment guides to position its content.
        self.overlay(alignment: .topLeading) {
            Image(systemName: "arrow.down")
            .foregroundStyle(.red.secondary)
            .alignmentGuide(.leading, moveTo: .center)
            .alignmentGuide(.top, moveTo: .bottom, outsetBy: 8)
        }
    }

    func floatingVerticalMarker() -> some View {
        // TODO: use floatingContent/FloatingAlignedContainer function when it actually uses alignment guides to position its content.
        self.overlay(alignment: .topLeading) {
            Image(systemName: "arrow.forward")
            .foregroundStyle(.red.secondary)
            .alignmentGuide(.leading, moveTo: .trailing, outsetBy: 8)
            .alignmentGuide(.top, moveTo: .center)
        }
    }

}
