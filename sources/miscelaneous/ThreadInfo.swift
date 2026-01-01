//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import RegexBuilder
import SwiftUI


nonisolated struct ThreadInfo {

    let number: Int?


    init() {
        let threadDescription = Thread.current.description
        let match = threadDescription.firstMatch {
            Regex {
                One("number = ")
                Capture {
                    OneOrMore(.digit)
                } transform: { match in
                    Int(match)
                }
            }
        }

        self.number = match?.1
    }


    var isMain: Bool { number == 1 }
    var isBackground: Bool { number != nil && number != 1 }


    var displayName: String {
        guard let number else {
            return "Unknown"
        }

        let name = isMain ? "Main" : "Background"
        return "\(name) \(number)"
    }

}


// FIXME: try to do these in a grid?
#Preview {
    @Previewable @State var appearThreadNumber: Int? = nil
    @Previewable @State var taskThreadNumber: Int? = nil
    @Previewable @State var innerTaskThreadNumber: Int? = nil
    @Previewable @State var detachedTaskThreadNumber: Int? = nil

    Text("OnAppear thread: \(appearThreadNumber, default: "nil")")
    Text("Task thread: \(taskThreadNumber, default: "nil")")
    Text("Inner Task thread: \(innerTaskThreadNumber, default: "nil")")
    Text("Detached Task thread: \(detachedTaskThreadNumber, default: "nil")")
    .onAppear {
        appearThreadNumber = ThreadInfo().number
    }
    .task {
        taskThreadNumber = ThreadInfo().number
        Task {
            innerTaskThreadNumber = ThreadInfo().number
        }
        Task.detached {
            let threadNumber = ThreadInfo().number
            await MainActor.run {
                detachedTaskThreadNumber = threadNumber
            }
        }
    }
}

