//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct CardIllustrations {

    static var formatStyles: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, drawsBorder: false) {
            VStack {
                Text("alfa, bravo, charlie")
                    .monospaced()
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("a, b, c")
                    .monospaced()
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("A, B, C")
                    .monospaced()
            }
            .frame(size: [220, 100])
            .background {
                RoundedRectangle(cornerRadius: Defaults.padding / 3)
                .fill(.indigo.gradient.secondary)
            }

        }
    }

}


// MARK: Previews


#Preview("formatStyles", traits: .docsIllustration) {
    CardIllustrations.formatStyles
}
