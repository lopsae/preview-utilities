//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Nonisolated sendable object that contains a concurrent async function, a explicit nonisolated
/// async function, and an async function with the default isolation, to inspect the thread running
/// in each function.
nonisolated
final class NonisolatedThreadChecker: Sendable {

    @concurrent
    func concurrentThreadNumber() async -> Int? {
        let threadNumber = ThreadInfo.currentThreadNumber()
        return threadNumber
    }


    nonisolated
    func nonisolatedThreadNumber() async -> Int? {
        let threadNumber = ThreadInfo.currentThreadNumber()
        return threadNumber
    }


    func defaultThreadNumber() -> Int? {
        let threadNumber = ThreadInfo.currentThreadNumber()
        return threadNumber
    }

}


// MARK: - Previews


#Preview("Nonisolated") {
    @Previewable @State var taskThreadNumber: Int? = nil
    @Previewable @State var taskConcurrentThreadNumber: Int? = nil
    @Previewable @State var taskNonisolatedThreadNumber: Int? = nil
    @Previewable @State var taskDefaultThreadNumber: Int? = nil
    @Previewable @State var detachedThreadNumber: Int? = nil
    @Previewable @State var detachedConcurrentThreadNumber: Int? = nil
    @Previewable @State var detachedNonisolatedThreadNumber: Int? = nil
    @Previewable @State var detachedDefaultThreadNumber: Int? = nil

    Text("Task thread: \(taskThreadNumber, default: "nil")")
    Text("Concurrent thread: \(taskConcurrentThreadNumber, default: "nil")")
    Text("Nonisolated thread: \(taskNonisolatedThreadNumber, default: "nil")")
    Text("Default isolation thread: \(taskDefaultThreadNumber, default: "nil")")
    Divider()
    Text("Detached thread: \(detachedThreadNumber, default: "nil")")
    Text("Concurrent thread: \(detachedConcurrentThreadNumber, default: "nil")")
    Text("Nonisolated thread: \(detachedNonisolatedThreadNumber, default: "nil")")
    Text("Default isolation thread: \(detachedDefaultThreadNumber, default: "nil")")
    Divider()
    .task {
        let checker = NonisolatedThreadChecker()
        taskThreadNumber = ThreadInfo.currentThreadNumber()
        taskConcurrentThreadNumber = await checker.concurrentThreadNumber()
        taskNonisolatedThreadNumber = await checker.nonisolatedThreadNumber()
        taskDefaultThreadNumber = await checker.defaultThreadNumber()
        Task.detached {
            detachedThreadNumber = ThreadInfo.currentThreadNumber()
            detachedConcurrentThreadNumber = await checker.concurrentThreadNumber()
            detachedNonisolatedThreadNumber = await checker.nonisolatedThreadNumber()
            detachedDefaultThreadNumber = await checker.defaultThreadNumber()
        }
    }


}
