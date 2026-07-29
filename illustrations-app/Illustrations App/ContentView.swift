//
//  Illustrations App
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .debugOverlay(.size, .alignment(.outerBottomTrailing))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
