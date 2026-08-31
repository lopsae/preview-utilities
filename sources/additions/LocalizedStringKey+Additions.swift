//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension LocalizedStringKey.StringInterpolation {

    mutating func appendInterpolation(systemImage name: String, label: String, useNbsp: Bool = true) {
        var label = " \(label)"
        if useNbsp {
            label = label.replacingOccurrences(of: " ", with: String.nbsp)
        }
        appendInterpolation(Image(systemName: name))
        appendInterpolation(label)
    }

    mutating func appendInterpolation(image resource: ImageResource, label: String, useNbsp: Bool = true) {
        var label = " \(label)"
        if useNbsp {
            label = label.replacingOccurrences(of: " ", with: String.nbsp)
        }
        appendInterpolation(Image(resource))
        appendInterpolation(label)
    }


    mutating func appendInterpolation(nonBreaking label: String) {
        let label = label.replacingOccurrences(of: " ", with: String.nbsp)
        appendInterpolation(label)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("Test before \(systemImage: "ladybug", label: "Ladybug image yes nbsp") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("Image+Label+YesNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(systemImage: "ladybug", label: "Ladybug image no nbsp", useNbsp: false) after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("Image+Label+NoNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(image: .moduleCatalog(.envelopeOffcenterBadgeTopTrailing), label: "Envelope Image") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("ImageResource+Label+YesNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(nonBreaking: "Non breaking text") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("String+NonBreaking", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Spacer()
}
