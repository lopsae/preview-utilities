//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import RegexBuilder
import SwiftUI


nonisolated struct ThreadInfo {

    static func currentThreadNumber() -> Int? {
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

        return match?.1
    }


    static func currentDisplayNumber() -> String {
        let threadNumber = currentThreadNumber()
        return threadNumber?.description ?? "nil"
    }

    static func currentDisplayName() -> String {
        let name = Thread.isMainThread ? "Main" : "Background"
        let number = currentDisplayNumber()
        return "\(name) \(number)"
    }

}


#Preview {
    @Previewable @State var appearThreadNumber: Int? = nil
    @Previewable @State var taskThreadNumber: Int? = nil
    @Previewable @State var innerTaskThreadNumber: Int? = nil
    @Previewable @State var detachedTaskThreadNumber: Int? = nil

    Text("Appear thread: \(appearThreadNumber, default: "nil")")
    Text("Task thread: \(taskThreadNumber, default: "nil")")
    Text("Inner Task thread: \(innerTaskThreadNumber, default: "nil")")
    Text("Detached Task thread: \(detachedTaskThreadNumber, default: "nil")")
    .onAppear {
        appearThreadNumber = ThreadInfo.currentThreadNumber()
    }
    .task {
        taskThreadNumber = ThreadInfo.currentThreadNumber()
        Task {
            innerTaskThreadNumber = ThreadInfo.currentThreadNumber()
        }
        Task.detached {
            let threadNumber = ThreadInfo.currentThreadNumber()
            await MainActor.run {
                detachedTaskThreadNumber = threadNumber
            }
        }
    }
}

