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
            .fill(.gray.quinary)
            .frame(squareOf: 100)

    }


    @Test func compositeAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all) {
            TestContent.single
            .debugAlignmentGuide(.topLeading)
            .debugAlignmentGuide(.center)
            .debugAlignmentGuide(.bottomTrailing)
        }

        Snapshots.assertView("firstTextBaseline", colorSchemes: .all) {
            TestContent.multi
            .debugAlignmentGuide(.leadingFirstTextBaseline)
        }

        Snapshots.assertView("lastTextBaseline", colorSchemes: .all) {
            TestContent.multi
            .debugAlignmentGuide(.trailingLastTextBaseline)
        }
    }


    @Test func horizontalAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all) {
            TestContent.single
            .debugAlignmentGuide(horizontal: .leading)
            .debugAlignmentGuide(horizontal: .center)
            .debugAlignmentGuide(horizontal: .trailing)
        }
    }


    @Test func verticalAlignments() {
        Snapshots.assertView("alignments", colorSchemes: .all) {
            TestContent.multi
            .debugAlignmentGuide(vertical: .top)
            .debugAlignmentGuide(vertical: .firstTextBaseline)
            .debugAlignmentGuide(vertical: .center)
            .debugAlignmentGuide(vertical: .lastTextBaseline)
            .debugAlignmentGuide(vertical: .bottom)
        }
    }

    @Test func alignmentsWithOpacity() {
        Snapshots.assertView("horizontal") {
            TestContent.single
            .debugAlignmentGuide(horizontal: .leading)
            .floatingHorizontalMarker(.leading)

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(true))
            .floatingHorizontalMarker(.leading)

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(false))
            .floatingHorizontalMarker(.leading)

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half))
            .floatingHorizontalMarker(.leading)

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .hidden)
            .floatingHorizontalMarker(.leading)

            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.one))
            .floatingHorizontalMarker(.leading)
        }

        Snapshots.assertView("vertical") {
            TestContent.single
            .debugAlignmentGuide(vertical: .top)
            .floatingVerticalMarker(.top)

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(true))
            .floatingVerticalMarker(.top)

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(false))
            .floatingVerticalMarker(.top)

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half))
            .floatingVerticalMarker(.top)

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .hidden)
            .floatingVerticalMarker(.top)

            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.one))
            .floatingVerticalMarker(.top)
        }

        Snapshots.assertView("composite") {
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


    @Test(.snapshots(record: .missing))
    func alignmentsWithStyle() {
        Snapshots.assertView("both", colorSchemes: .all) {
            TestContent.single
            .debugAlignmentGuide(horizontal: .center, .style(.green.secondary))
            .debugAlignmentGuide(vertical: .center, .style(.blue.secondary))
        }

        Snapshots.assertView("composite", colorSchemes: .all) {
            TestContent.single
            .debugAlignmentGuide(.center, .style(.green.secondary))
        }

        Snapshots.assertView("compositeBoth", colorSchemes: .all) {
            TestContent.single
            .debugAlignmentGuide(.topLeading, .style(horizontal: .green.secondary, vertical: .blue.secondary))
            .debugAlignmentGuide(.bottomTrailing, .style(horizontal: .orange.secondary, vertical: .purple.secondary))
        }

        Snapshots.assertView("compositeEach") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.bottomLeading, .style(horizontal: .green.secondary))
            .debugAlignmentGuide(.topTrailing, .style(vertical: .blue.secondary))
        }
    }


    @Test(.snapshots(record: .missing))
    func alignmentsWithLineWidth() {
        Snapshots.assertView("horizontal") {
            TestContent.single
            .edgeGraticule(insetSpacing: 10, through: 1)
            .debugAlignmentGuide(horizontal: .leading,  .lineWidth(10))
            .debugAlignmentGuide(horizontal: .center,   .lineWidth(1))
            .debugAlignmentGuide(horizontal: .trailing, .lineWidth(20))
        }

        Snapshots.assertView("vertical") {
            TestContent.single
            .edgeGraticule(insetSpacing: 10, through: 1)
            .debugAlignmentGuide(vertical: .top,    .lineWidth(10))
            .debugAlignmentGuide(vertical: .center, .lineWidth(1))
            .debugAlignmentGuide(vertical: .bottom, .lineWidth(20))
        }

        Snapshots.assertView("baselines") {
            TestContent.multi
            .debugAlignmentGuide(vertical: .firstTextBaseline, .lineWidth(10))
            .debugAlignmentGuide(vertical: .lastTextBaseline,  .lineWidth(10))
        }

        Snapshots.assertView("zero") {
            TestContent.multi
            .debugAlignmentGuide(horizontal: .center, .lineWidth(.zero))
            .floatingHorizontalMarker(.center)
            .debugAlignmentGuide(vertical: .center,  .lineWidth(.zero))
            .floatingVerticalMarker(.center)
        }

        Snapshots.assertView("composite") {
            TestContent.single
            .debugAlignmentGuide(.center, .lineWidth(10))
        }

        Snapshots.assertView("compositeBoth") {
            TestContent.single
            .debugAlignmentGuide(.center, .lineWidth(horizontal: 10, vertical: 20))
        }

        Snapshots.assertView("compositeEach") {
            TestContent.single
            .debugAlignmentGuide(.bottomLeading, .lineWidth(horizontal: 20))
            .debugAlignmentGuide(.topTrailing, .lineWidth(vertical: 20))
        }
    }


    @Test func alignmentsWithLengths() {
        Snapshots.assertView("compositeEach") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.topLeading, .length(horizontal: .extended(50)))
            .debugAlignmentGuide(.bottomTrailing, .length(vertical: .fixed(70)))
        }

        Snapshots.assertView("compositeBoth") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.center, .length(horizontal: .extended(50), vertical: .fixed(70)))
        }
    }

    @Test(.snapshots(record: .missing))
    func alignmentsWithFixedLength() {
        Snapshots.assertView("horizontal") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(horizontal: .leading,  .fixedLength(150))
            .debugAlignmentGuide(horizontal: .center,   .fixedLength(.zero))
            .debugAlignmentGuide(horizontal: .trailing, .fixedLength(70))
        }

        Snapshots.assertView("vertical") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(vertical: .top,    .fixedLength(150))
            .debugAlignmentGuide(vertical: .center, .fixedLength(.zero))
            .debugAlignmentGuide(vertical: .bottom, .fixedLength(70))
        }

        Snapshots.assertView("negatives") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(horizontal: .leading, .fixedLength(-70))
            .floatingHorizontalMarker(.leading)
            .debugAlignmentGuide(vertical: .top,       .fixedLength(-70))
            .floatingVerticalMarker(.top)
        }

        Snapshots.assertView("compositeBoth") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.topLeading,     .fixedLength(150))
            .debugAlignmentGuide(.center,         .fixedLength(.zero))
            .debugAlignmentGuide(.bottomTrailing, .fixedLength(70))
        }

        Snapshots.assertView("compositeEach") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.topLeading, .fixedLength(horizontal: 150), .style(horizontal: .green.secondary))
            .debugAlignmentGuide(.bottomTrailing, .fixedLength(vertical: 70), .style(vertical: .green.secondary))
        }
    }


    @Test(.snapshots(record: .missing))
    func alignmentsWithExtendedLength() {
        Snapshots.assertView("horizontal") {
            TestContent.single
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(horizontal: .leading,  .extendLength(50))
            .debugAlignmentGuide(horizontal: .center,   .extendLength(.zero))
            .debugAlignmentGuide(horizontal: .trailing, .extendLength(-30))
        }

        Snapshots.assertView("vertical") {
            TestContent.single
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(vertical: .top,    .extendLength(50))
            .debugAlignmentGuide(vertical: .center, .extendLength(.zero))
            .debugAlignmentGuide(vertical: .bottom, .extendLength(-30))
        }

        Snapshots.assertView("negatives") {
            TestContent.square
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(horizontal: .leading, .extendLength(-130))
            .floatingHorizontalMarker(.leading)
            .debugAlignmentGuide(vertical: .top,       .extendLength(-130))
            .floatingVerticalMarker(.top)
        }

        Snapshots.assertView("compositeBoth") {
            TestContent.single
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.topLeading,     .extendLength(50))
            .debugAlignmentGuide(.center,         .extendLength(.zero))
            .debugAlignmentGuide(.bottomTrailing, .extendLength(-30))
        }


        Snapshots.assertView("compositeEach") {
            TestContent.single
            .edgeGraticule(insetSpacing: 15, outsetSpacing: 25)
            .debugAlignmentGuide(.topLeading, .extendLength(horizontal: 50), .style(horizontal: .green.secondary))
            .debugAlignmentGuide(.bottomTrailing, .extendLength(vertical: -30), .style(vertical: .green.secondary))
        }
    }


    @Test(.snapshots(record: .missing))
    func alignmentsWithScaledLength() {
        Snapshots.assertView("horizontal") {
            TestContent.square
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(horizontal: .leading,  .scaleLength(1.4))
            .debugAlignmentGuide(horizontal: .center,   .scaleLength(.one))
            .debugAlignmentGuide(horizontal: .trailing, .scaleLength(0.6))
        }

        Snapshots.assertView("vertical") {
            TestContent.square
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(vertical: .top,    .scaleLength(1.4))
            .debugAlignmentGuide(vertical: .center, .scaleLength(.one))
            .debugAlignmentGuide(vertical: .bottom, .scaleLength(0.6))
        }

        Snapshots.assertView("negatives") {
            TestContent.square
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(horizontal: .leading, .scaleLength(-1))
            .floatingHorizontalMarker(.leading)
            .debugAlignmentGuide(vertical: .top,       .scaleLength(-1))
            .floatingVerticalMarker(.top)
        }

        Snapshots.assertView("compositeBoth") {
            TestContent.square
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(.topLeading,     .scaleLength(1.4))
            .debugAlignmentGuide(.center,         .scaleLength(.one))
            .debugAlignmentGuide(.bottomTrailing, .scaleLength(0.6))
        }


        Snapshots.assertView("compositeEach") {
            TestContent.square
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(.topLeading, .scaleLength(horizontal: 1.4), .style(horizontal: .green.secondary))
            .debugAlignmentGuide(.bottomTrailing, .scaleLength(vertical: 0.6), .style(vertical: .green.secondary))
        }
    }


    @Test(.snapshots(record: .missing))
    func alignmentsWithAnchor() {
        Snapshots.assertView("horizontal") {
            TestContent.single
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(horizontal: .leading,  .extendLength(20),    .anchor(.top))
            .debugAlignmentGuide(horizontal: .center,   .extendLength(.zero), .anchor(.center))
            .debugAlignmentGuide(horizontal: .trailing, .extendLength(-20),   .anchor(.bottom))
        }

        Snapshots.assertView("baselines") {
            TestContent.multi
            .debugAlignmentGuide(vertical: .lastTextBaseline, .style(.tertiary))
            .debugAlignmentGuide(vertical: .firstTextBaseline, .style(.tertiary))
            .debugAlignmentGuide(horizontal: .leading,  .fixedLength(120),  .anchor(.lastTextBaseline))
            .debugAlignmentGuide(horizontal: .trailing, .fixedLength(40),   .anchor(.firstTextBaseline))

        }

        Snapshots.assertView("vertical") {
            TestContent.single
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(vertical: .top,    .extendLength(20),    .anchor(.leading))
            .debugAlignmentGuide(vertical: .center, .extendLength(.zero), .anchor(.center))
            .debugAlignmentGuide(vertical: .bottom, .extendLength(-20),   .anchor(.trailing))
        }

        Snapshots.assertView("composite") {
            TestContent.single
            .edgeGraticule(spacing: 20)
            .debugAlignmentGuide(.topLeading,     .extendLength(20),    .anchor(.topTrailing))
            .debugAlignmentGuide(.center,         .extendLength(.zero), .anchor(.center))
            .debugAlignmentGuide(.bottomTrailing, .extendLength(-20),   .anchor(.bottomLeading))
        }
    }

}


private extension View {

    @ViewBuilder
    func floatingHorizontalMarker(_ horizontalAlignment: HorizontalAlignment) -> some View {
        // TODO: use floatingContent/FloatingAlignedContainer function when it actually uses alignment guides to position its content.
        let alignment = horizontalAlignment.alignment(withOrthogonal: .top)
        self.overlay(alignment: alignment) {
            Image(systemName: "arrow.down")
            .foregroundStyle(.red.secondary)
            .alignmentGuide(horizontalAlignment, moveTo: .center)
            .alignmentGuide(.top, moveTo: .bottom, outsetBy: 8)
        }
    }

    @ViewBuilder
    func floatingVerticalMarker(_ verticalAlignment: VerticalAlignment) -> some View {
        // TODO: use floatingContent/FloatingAlignedContainer function when it actually uses alignment guides to position its content.
        let alignment = verticalAlignment.alignment(withOrthogonal: .leading)
        self.overlay(alignment: alignment) {
            Image(systemName: "arrow.forward")
            .foregroundStyle(.red.secondary)
            .alignmentGuide(verticalAlignment, moveTo: .center)
            .alignmentGuide(.leading, moveTo: .trailing, outsetBy: 8)
        }
    }

}
