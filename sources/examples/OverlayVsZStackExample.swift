//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


#Preview("Example: .overlay", traits: .headerFooter) {
    Text("""
        Overlay allows its content to overflow around the owner view, without modifying the owner
        position or size.
        """)
    .foregroundStyle(.secondary)
    .padding([.horizontal, .bottom])

    Rectangle()
        .strokeBorder(.red, lineWidth: 10)
        .frame(squareOf: 50)
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
            }.fixedSize()
        }
        .border(.orange, width: 4)

}


#Preview("Example: ZStack", traits: .headerFooter) {
    Text("""
        ZStack of the same elements, where the ZStack grows to accomodate the size of all contained
        elements
        """)
    .foregroundStyle(.secondary)
    .padding([.horizontal, .bottom])

    ZStack(alignment: .topLeading) {
        Rectangle()
            .strokeBorder(.red, lineWidth: 10)
            .frame(squareOf: 50)
        VStack(alignment: .leading) {
            Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
        }.fixedSize()
    }
    .border(.orange, width: 4)

}


#Preview("Overlay+GeometryReader alignment", traits: .headerFooter) {
    Text("""
        GeometryReader takes the size of its container, even if the content is bigger. Bigger
        content is always alignedtopLeading with no possible way to modify it through
        GeometryReader.
        """)
    .foregroundStyle(.secondary)
    .padding([.horizontal, .bottom])

    Rectangle()
        .fill(.red.opacity(0.3))
        .frame(squareOf: 60)
        .overlay(alignment: .bottomTrailing) {
            // Geometry reader will remain the size of its container, even if content is bigger.
            GeometryReader { geometry in
                let sizeIncrease: CGFloat = 40
                // Bigger content is always aligned to topLeading, with no ways to modify it.
                Rectangle()
                    .stroke(.orange, lineWidth: 5)
                    .frame(size: geometry.size.add(width: sizeIncrease, height: sizeIncrease))

                // However offset can still reposition the display of the contained view.
                let offset: CGFloat = -sizeIncrease / 2
                Rectangle()
                    .stroke(.purple, lineWidth: 5)
                    .frame(size: geometry.size.add(width: sizeIncrease, height: sizeIncrease))
                    .offset(x: offset, y: offset)
            }
            .debugOverlay()
        }

}
