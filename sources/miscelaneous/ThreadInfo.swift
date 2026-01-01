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


    /// Returns the name and number of the thread for display, E.g.: `Main 1` or `Background 7`.
    var displayName: String {
        guard let number else {
            return "Unknown"
        }

        let name = isMain ? "Main" : "Background"
        return "\(name) \(number)"
    }


    /// Returns the number and name of the thread for display, with the number first, E.g.: `1 Main`
    /// or `7 Background`.
    var numberLeadingDisplayName: String {
        guard let number else {
            return "Unknown"
        }

        let name = isMain ? "Main" : "Background"
        return "\(number) \(name)"
    }

}


#Preview(traits: .regularSpacing, .headerFooter) {
    @Previewable @State var appearThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskThreadInfo: ThreadInfo? = nil
    @Previewable @State var innerTaskThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedTaskThreadInfo: ThreadInfo? = nil

    Grid(alignment: .leading, horizontalSpacing: 20) {
        GridRow {
            Text("Context").bold()
            Text("Thread").bold().maxWidthFrame(alignment: .leading)
        }

        Divider().gridCellUnsizedAxes(.horizontal)

        GridRow {
            Text("On Appear")
            Text(appearThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Task")
            Text(taskThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Inner Task")
            Text(innerTaskThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Detached Task")
            Text(detachedTaskThreadInfo?.numberLeadingDisplayName ?? "…")
        }
    } // Grid
    .padding(.horizontal)
    .onAppear {
        appearThreadInfo = ThreadInfo()
    }
    .task {
        try? await Task.sleep(for: .seconds(2))
        taskThreadInfo = ThreadInfo()
        Task {
            innerTaskThreadInfo = ThreadInfo()
        }
        Task.detached {
            let threadInfo = ThreadInfo()
            await MainActor.run {
                detachedTaskThreadInfo = threadInfo
            }
        }
    }
}

