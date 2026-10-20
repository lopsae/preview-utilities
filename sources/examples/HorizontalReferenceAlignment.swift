//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
private protocol HorizontalReferenceAlignmentID: AlignmentID, Sendable {
    static var referenceAlignment: HorizontalAlignment { get }
    static var relativeAlignment: HorizontalAlignment { get }
}

extension HorizontalReferenceAlignmentID {

    nonisolated
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[horizontal: relativeAlignment]
    }

}


nonisolated
private struct OuterTrailing: HorizontalReferenceAlignmentID {
    static let referenceAlignment: HorizontalAlignment = .trailing
    static let relativeAlignment: HorizontalAlignment = .leading
}


nonisolated
private extension HorizontalAlignment {
    static let outerTrailing = HorizontalAlignment(OuterTrailing.self)
}


nonisolated
private struct HorizontalReferenceAlignment: Sendable {
    let alignmentID: HorizontalReferenceAlignmentID.Type

    init(_ alignmentID: HorizontalReferenceAlignmentID.Type) {
        self.alignmentID = alignmentID
    }

    /// The `HorizontalAlignment` instance used by this reference alignment.
    var horizontalAlignment: HorizontalAlignment { .init(alignmentID) }
    var reference: HorizontalAlignment { alignmentID.referenceAlignment }
    var relative: HorizontalAlignment { alignmentID.relativeAlignment }

}


/// Static members available as parameter shorthands.
extension HorizontalReferenceAlignment {
    static let outerTrailing: Self = .init(OuterTrailing.self)
}



private extension View {
    func alignmentGuide(referenceOf referenceAlignment: HorizontalReferenceAlignment) -> some View {
        self.alignmentGuide(referenceAlignment.horizontalAlignment) { dimension in
            dimension[referenceAlignment.alignmentID.referenceAlignment]
        }
    }
}


// MARK: - Previews


#Preview("Default") {
    VStack(alignment: .outerTrailing) {
        Text("Reference\nManual")
        .multilineTextAlignment(.trailing)
        .fontWeight(.bold)
        // Manual setup or reference alignment.
        .alignmentGuide(.outerTrailing) { dimension in
            dimension[referenceOf: .outerTrailing]
        }

        Text("Relative One")
        Text("Relative Two")
    }


    DashedDivider()

    VStack(alignment: .outerTrailing) {
        Text("Reference\n`referenceOf`")
        .multilineTextAlignment(.trailing)
        .fontWeight(.bold)
        .alignmentGuide(referenceOf: .outerTrailing)
        // FIXME: Could this be just .referenceAlignment() using Environment values?

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

    nonisolated
    subscript(referenceOf guide: HorizontalReferenceAlignment) -> CGFloat {
        self[horizontal: guide.reference]
    }

}
