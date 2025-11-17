//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct HeaderFooterPreview<Content: View>: View {

    let options: HeaderFooterPreviewOptions
    let content: Content


    init(options: HeaderFooterPreviewOptions = [], @ViewBuilder content: () -> Content) {
        self.content = content()
        self.options = options
    }


    var body: some View {
        VStack(spacing: 0) {
            VStack (spacing: 0) {
                Text("Header")
                    .foregroundStyle(.tertiary)
                    // Double padding to account for background padding.
                    .padding(.bottom)
                    .padding(.bottom)
                    .maxWidthFrame()

                if !options.contains(.fixedHeader) {
                    Spacer()
                }

            }
            .background {
                ConcentricRectangle(corners: .concentric(minimum: 12))
                .fill(.gray.tertiary)
                .padding()
                .ignoresSafeArea()
            }

            if options.contains(.showDividers) {
                Divider()
            }

            content

            if options.contains(.showDividers) {
                Divider()
            }

            VStack (spacing: 0) {
                if !options.contains(.fixedFooter) {
                    Spacer()
                }
                Text("Footer")
                    .foregroundStyle(.tertiary)
                    // Double padding to account for background padding.
                    .padding(.top)
                    .padding(.top)
                    .maxWidthFrame()
            }
            .background {
                ConcentricRectangle(corners: .concentric(minimum: 12))
                .fill(.gray.tertiary)
                .padding()
                .ignoresSafeArea()
            }
        }
    }

}


struct HeaderFooterPreviewOptions: OptionSet {

    let rawValue: Int


    static let fixedHeader: Self  = .init(shiftedBy: 0)
    static let fixedFooter: Self  = .init(shiftedBy: 1)
    static let showDividers: Self = .init(shiftedBy: 2)

    static let fixed: Self = [.fixedHeader, .fixedFooter]

}


#Preview("Default") {
    HeaderFooterPreview {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Header") {
    HeaderFooterPreview(options: .fixedHeader) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


// TODO: footer looks too tall in watchOS
#Preview("Fixed Footer") {
    HeaderFooterPreview(options: .fixedFooter) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Both") {
    HeaderFooterPreview(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


// TODO: with an element of a set height, header and footer have display issues
// TODO: in macOS, in all cases, footer is displayed too close to edge
#Preview("Fixed Both, Inflexible") {
    HeaderFooterPreview(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
            .frame(width: 100, height: 100)
    }
}


#Preview("Show Dividers") {
    HeaderFooterPreview(options: .showDividers) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Multiple traits") {
    HeaderFooterPreview(options: [.fixed, .showDividers]) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}
