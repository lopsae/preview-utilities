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
