//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Nonisolated sendable object that contains a concurrent async function, a explicit nonisolated
/// async function, and an async function with the default isolation; to inspect the thread running
/// in each function.
nonisolated
final class NonisolatedThreadChecker: Sendable {

    @concurrent
    func concurrentThreadInfo() async -> ThreadInfo { .init() }

    nonisolated
    func nonisolatedThreadInfo() async -> ThreadInfo { .init() }

    func defaultIsolationThreadInfo() async -> ThreadInfo { .init() }

}


// MARK: - Previews


#Preview("Nonisolated", traits: .regularSpacing, .headerFooter) {
    @Previewable @State var taskThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskConcurrentThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskNonisolatedThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskDefaultIsolationThreadInfo: ThreadInfo? = nil

    @Previewable @State var detachedThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedConcurrentThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedNonisolatedThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedDefaultIsolationThreadInfo: ThreadInfo? = nil

    Grid(alignment: .leading, horizontalSpacing: 20) {
        GridRow {
            Text("In Task").bold()
            Text("Thread").bold().maxWidthFrame(alignment: .leading)
        }

        Divider().gridCellUnsizedAxes(.horizontal)

        GridRow {
            Text("Parent")
            Text(taskThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Concurrent")
            Text(taskConcurrentThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Non Isolated")
            Text(taskNonisolatedThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Default Isolation")
            Text(taskDefaultIsolationThreadInfo?.numberLeadingDisplayName ?? "…")
        }

        Divider().gridCellUnsizedAxes(.horizontal)

        GridRow {
            Text("In Detached").bold()
            Text("Thread").bold().maxWidthFrame(alignment: .leading)
        }

        Divider().gridCellUnsizedAxes(.horizontal)

        GridRow {
            Text("Parent")
            Text(detachedThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Concurrent")
            Text(detachedConcurrentThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Non Isolated")
            Text(detachedNonisolatedThreadInfo?.numberLeadingDisplayName ?? "…")
        }
        GridRow {
            Text("Default Isolation")
            Text(detachedDefaultIsolationThreadInfo?.numberLeadingDisplayName ?? "…")
        }
    } // Grid
    .padding(.horizontal)
    .task {
        let checker = NonisolatedThreadChecker()
        taskThreadInfo = ThreadInfo()
        taskConcurrentThreadInfo = await checker.concurrentThreadInfo()
        taskNonisolatedThreadInfo = await checker.nonisolatedThreadInfo()
        taskDefaultIsolationThreadInfo = await checker.defaultIsolationThreadInfo()
        Task.detached {
            try? await Task.sleep(for: .seconds(2))
            // Experimental way to assign a state in main.
            await _detachedThreadInfo.setOnMain(ThreadInfo())
            await $detachedConcurrentThreadInfo.setOnMain(await checker.concurrentThreadInfo())
            await $detachedNonisolatedThreadInfo.setOnMain(await checker.nonisolatedThreadInfo())
            await $detachedDefaultIsolationThreadInfo.setOnMain(await checker.defaultIsolationThreadInfo())
        }
    }

}


extension State {

    @MainActor
    func setOnMain(_ newValue: Value) {
        self.wrappedValue = newValue
    }

}


extension Binding {

    @MainActor
    func setOnMain(_ newValue: Value) {
        self.wrappedValue = newValue
    }

}


extension DefaultStringInterpolation {

    mutating func appendInterpolation(nilDefault string: String?) {
        appendInterpolation(string, default: "nil")
    }

    mutating func appendInterpolation(emptyDefault string: String?) {
        appendInterpolation(string, default: "")
    }

}
