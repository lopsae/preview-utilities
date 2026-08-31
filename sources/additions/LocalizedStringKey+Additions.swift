//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

#if canImport(UIKit)
//import UIKit
private typealias PlatformFont = UIFont
#elseif canImport(AppKit)
//import AppKit
private typealias PlatformFont = NSFont
#endif


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


    mutating func appendInterpolation(
        button systemImage: String,
        label: String,
        color: Color = .accentColor
    ) {
        let renderer = ImageRenderer(
            content: CapsuleText(systemImage: systemImage, label: label, color: color)
        )
        renderer.scale = 3

        guard let cgImage = renderer.cgImage else {
            appendInterpolation(Image(systemName: systemImage))
            appendInterpolation(label)
            return
        }

        // Calculate baseline.
        // TODO: Move to CapsuleText
        let bottomPadding = Defaults.padding / 4
        let descender = PlatformFont.preferredFont(forTextStyle: .body).descender
        let baselineFromBottom = bottomPadding - descender

        let image = Image(decorative: cgImage, scale: renderer.scale)
        appendInterpolation(Text(image).baselineOffset(-baselineFromBottom))
    }

}


private struct CapsuleText: View {

    let systemImage: String
    let label: String
    let color: Color

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Defaults.padding / 3) {
            Image(systemName: systemImage)
            Text(label)
        }
        .font(.body)
        .foregroundStyle(color)
        .padding(.horizontal, Defaults.padding / 2)
        .padding(.vertical, Defaults.padding / 4)
        .background {
            Capsule()
            .strokeBorder(color, style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
        }
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

    DashedDivider()

    Text("Tap \(button: "plus.circle", label: "Add Item", color: .orange) to insert a new row")
    .frame(width: fixedWidth)
    .floatingCaption("Button+DashedCapsule", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Spacer()
}
