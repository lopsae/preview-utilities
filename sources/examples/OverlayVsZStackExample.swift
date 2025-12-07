//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// Previews to show the differente between stacking content of different sizes using a `ZStack` or
// an `.overlay` view modifier.


// Overlay allows its content to overflow around the owner view, without modifying the owner
// position or size.
#Preview("Example: .overlay", traits: .headerFooter) {

    Rectangle()
        .strokeBorder(.red, lineWidth: 10)
        .frame(square: 50)
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
            }.fixedSize()
        }
        .border(.orange, width: 4)

}


// ZStack of the same elements, where the ZStack grows to accomodate the size of all contained
// elements.
#Preview("Example: ZStack", traits: .headerFooter) {

    ZStack(alignment: .topLeading) {
        Rectangle()
            .strokeBorder(.red, lineWidth: 10)
            .frame(square: 50)
        VStack(alignment: .leading) {
            Text("Lorem ipsum dolor sit ame,\nconsectetur adipiscing elit.")
        }.fixedSize()
    }
    .border(.orange, width: 4)

}


#Preview("Overlay+GeometryReader alignment", traits: .headerFooter) {

    Rectangle()
        .fill(.red.opacity(0.3))
        .frame(square: 60)
        .overlay(alignment: .bottomTrailing) {
            // Geometry reader will remain the size of its container, even if content is bigger.
            GeometryReader { geometry in
                let sizeIncrease: CGFloat = 40
                // Bigger content is always aligned to topLeading, with no ways to modify it.
                Rectangle()
                    .stroke(.orange, lineWidth: 5)
                    .frame(size: geometry.size.add(width: sizeIncrease, height: sizeIncrease))

                // However offset can still reposition the display of the containe view.
                let offset: CGFloat = -sizeIncrease / 2.0
                Rectangle()
                    .stroke(.purple, lineWidth: 5)
                    .frame(size: geometry.size.add(width: sizeIncrease, height: sizeIncrease))
                    .offset(x: offset, y: offset)
            }
            .debugOutline()
        }

}
