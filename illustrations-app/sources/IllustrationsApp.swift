//
//  Illustrations App
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


@main
struct IllustrationsApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "printer")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("PreviewUtilities")
            Text("Illustrations App")
                .debugOverlay(.size, .alignment(.outerBottomTrailing))
        }
        .padding()
    }
}


#Preview {
    ContentView()
}

