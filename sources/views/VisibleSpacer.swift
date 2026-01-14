//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct VisibleSpacer: View {

    var body: some View {
        Text("Spacer")
        .foregroundStyle(.tertiary)
        .font(.caption)
        .padding(.horizontal, 8)
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(.gray.quaternary)
    }

}
