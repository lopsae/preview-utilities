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


#Preview("Nonisolated", traits: .fixedHeader) {
    @Previewable @State var taskThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskConcurrentThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskNonisolatedThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskDefaultThreadInfo: ThreadInfo? = nil

    @Previewable @State var detachedThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedConcurrentThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedNonisolatedThreadInfo: ThreadInfo? = nil
    @Previewable @State var detachedDefaultThreadInfo: ThreadInfo? = nil

    Divider()
    Text("Task thread: \(emptyDefault: taskThreadInfo?.reverseDisplayName)")
    Text("Concurrent thread: \(emptyDefault: taskConcurrentThreadInfo?.reverseDisplayName)")
    Text("Nonisolated thread: \(emptyDefault: taskNonisolatedThreadInfo?.reverseDisplayName)")
    Text("Default isolation thread: \(emptyDefault: taskDefaultThreadInfo?.reverseDisplayName)")
    Divider()
    Text("Detached thread: \(nilDefault: detachedThreadInfo?.reverseDisplayName)")
    Text("Concurrent thread: \(nilDefault: detachedConcurrentThreadInfo?.reverseDisplayName)")
    Text("Nonisolated thread: \(nilDefault: detachedNonisolatedThreadInfo?.reverseDisplayName)")
    Text("Default isolation thread: \(nilDefault: detachedDefaultThreadInfo?.reverseDisplayName)")
    Divider()
    .task {
        let checker = NonisolatedThreadChecker()
        taskThreadInfo = ThreadInfo()
        taskConcurrentThreadInfo = await checker.concurrentThreadInfo()
        taskNonisolatedThreadInfo = await checker.nonisolatedThreadInfo()
        taskDefaultThreadInfo = await checker.defaultIsolationThreadInfo()
        Task.detached {
            try? await Task.sleep(for: .seconds(2))
            // Experimental way to assign a state in main.
            await _detachedThreadInfo.setOnMain(ThreadInfo())
            await $detachedConcurrentThreadInfo.setOnMain(checker.concurrentThreadInfo())
            await $detachedNonisolatedThreadInfo.setOnMain(await checker.nonisolatedThreadInfo())
            await $detachedDefaultThreadInfo.setOnMain(await checker.defaultIsolationThreadInfo())
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
