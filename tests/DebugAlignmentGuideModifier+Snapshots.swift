//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DebugAlignmentGuideModifierSnapshots {

    @Test func horizontalAlignments() {
        Snapshots.assertView(named: "alignments", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
            .debugAlignmentGuide(horizontal: .leading)
            .debugAlignmentGuide(horizontal: .center)
            .debugAlignmentGuide(horizontal: .trailing)
        }
    }


    @Test func verticalAlignments() {
        Snapshots.assertView(named: "alignments", record: .never) {
            Text("Sphinx\nof Black\nQuartz")
            .font(.largeTitle)
            .debugAlignmentGuide(vertical: .top)
            .debugAlignmentGuide(vertical: .firstTextBaseline)
            .debugAlignmentGuide(vertical: .center)
            .debugAlignmentGuide(vertical: .lastTextBaseline)
            .debugAlignmentGuide(vertical: .bottom)
        }
    }

    @Test func axisAlignmentsWithOpacity() {
        Snapshots.assertView(named: "horizontal", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
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

        Snapshots.assertView(named: "vertical", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
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
    }

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
