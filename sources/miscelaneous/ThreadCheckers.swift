//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Nonisolated sendable object that contains a concurrent async function, a explicit nonisolated
/// async function, and an async function with the default isolation; to inspect the thread running
/// in each function.
nonisolated
public final class NonisolatedThreadChecker: Sendable {

    public init() {}

    @concurrent
    public func concurrentThreadInfo() async -> ThreadInfo { .init() }

    nonisolated
    public func nonisolatedThreadInfo() async -> ThreadInfo { .init() }

    // Since the class is nonisolated, this function behaves the same as `nonisolatedThreadInfo`.
    public func defaultIsolationThreadInfo() async -> ThreadInfo { .init() }

}


/// Sendable object that uses the default project isolation context, which is configured to
/// `MainActor`.
public final class DefaultIsolationThreadChecker: Sendable {

    public init() {}

    /// Given that the class uses the default `MainActor` isolation, this function will always be
    /// called in `MainActor`, irregardless of the parent isolation context.
    public func defaultIsolationThreadInfo() async -> ThreadInfo { .init() }

}


// MARK: - Previews


#Preview("Nonisolated", traits: .headerFooter) {
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


#Preview("DefaultIsolation", traits: .headerFooter) {
    @Previewable @State var taskThreadInfo: ThreadInfo? = nil
    @Previewable @State var taskDefaultIsolationThreadInfo: ThreadInfo? = nil

    @Previewable @State var detachedThreadInfo: ThreadInfo? = nil
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
            Text("Default Isolation")
            Text(detachedDefaultIsolationThreadInfo?.numberLeadingDisplayName ?? "…")
        }
    } // Grid
    .task {
        let checker = DefaultIsolationThreadChecker()
        taskThreadInfo = ThreadInfo()
        taskDefaultIsolationThreadInfo = await checker.defaultIsolationThreadInfo()
        Task.detached {
            try? await Task.sleep(for: .seconds(2))
            // Experimental way to assign a state in main.
            await $detachedThreadInfo.setOnMain(ThreadInfo())
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
