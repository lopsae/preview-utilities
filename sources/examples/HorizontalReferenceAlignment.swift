//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
private protocol HorizontalReferenceAlignmentID: AlignmentID, Sendable {
    static var reference: HorizontalAlignment { get }
    static var relative: HorizontalAlignment { get }

    // FIXME: Could have a default implementation for defaultValue.
}


nonisolated
private struct OuterTrailing: HorizontalReferenceAlignmentID {
    static let reference: HorizontalAlignment = .trailing
    static let relative: HorizontalAlignment = .leading
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[horizontal: relative]
    }
}


nonisolated
private extension HorizontalAlignment {
    static let outerTrailing = HorizontalAlignment(OuterTrailing.self)
}



nonisolated
private struct HorizontalReferenceAlignment: Sendable {
    let alignmentID: HorizontalReferenceAlignmentID.Type
    let anchorAlignment: HorizontalAlignment

    init(_ alignmentID: HorizontalReferenceAlignmentID.Type) {
        self.alignmentID = alignmentID
        // FIXME: almost sure this should be initialized with outer.
        self.anchorAlignment = .init(alignmentID)
    }

    static let outerTrailing = HorizontalReferenceAlignment(OuterTrailing.self)
}

private extension View {
    func alignmentGuide(referenceOf referenceAlignment: HorizontalReferenceAlignment) -> some View {
        self.alignmentGuide(referenceAlignment.anchorAlignment) { dimension in
            dimension[referenceAlignment.alignmentID.reference]
        }
    }
}


// MARK: - Previews


#Preview("Default") {
    VStack(alignment: .outerTrailing) {
        Text("Reference").fontWeight(.bold)
        // FIXME: Manual setup of ReferenceAlignment
        .alignmentGuide(.outerTrailing) { dimension in
            dimension[OuterTrailing.reference]
        }

        Text("Relative One")
        Text("Relative Two")
    }
}


#Preview("NoReference") {
    VStack(alignment: .outerTrailing) {
        Text("No Reference").fontWeight(.bold)
        Text("1st Relative")
        Text("Second Relative")
    }
}


private extension ViewDimensions {

    nonisolated
    subscript(horizontal guide: HorizontalAlignment) -> CGFloat {
        self[guide]
    }

    nonisolated
    subscript(vertical guide: VerticalAlignment) -> CGFloat {
        self[guide]
    }

}
