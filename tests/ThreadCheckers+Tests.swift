//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct ThreadCheckerTests {

    @MainActor
    @Test func nonisoltedThreadChecked() async throws {
        let threadChecker = NonisolatedThreadChecker()

        let currentThreadInfo = ThreadInfo()
        // Test should be running in the Main thread.
        #expect(currentThreadInfo.isMain)

        let concurrentThreadInfo = await threadChecker.concurrentThreadInfo()
        // Concurrent isolation should always send to a background thread.
        #expect(concurrentThreadInfo.isBackground)

        let nonisolatedThreadInfo = await threadChecker.nonisolatedThreadInfo()
        // Nonisolated should inherit the current isolation context: Main.
        #expect(nonisolatedThreadInfo.isMain)

        let defaultIsolationThreadInfo = await threadChecker.defaultIsolationThreadInfo()
        // Default isolation should inherit the current isolation context: Main.
        #expect(defaultIsolationThreadInfo.isMain)

        let detachedTask = Task.detached {
            // #expect failures do not work correctly in detached tasks, since the testing context
            // is lost. The #expect may fail, but the test will be marked as passed!
            return (
                detachedInfo: ThreadInfo(),
                concurrentInfo: await threadChecker.concurrentThreadInfo(),
                nonisolatedInfo: await threadChecker.nonisolatedThreadInfo(),
                defaultIsolationInfo: await threadChecker.defaultIsolationThreadInfo()
            )
        }

        let detachedResult = await detachedTask.value
        // Detached task should run in a background thread.
        #expect(detachedResult.detachedInfo.isBackground)
        // Concurrent isolation should run in a background thread.
        #expect(detachedResult.concurrentInfo.isBackground)
        // Nonisolated should inherit the current isolation context.
        #expect(detachedResult.nonisolatedInfo.number == detachedResult.detachedInfo.number)
        // Default isolation should inherit the current isolation context.
        #expect(detachedResult.defaultIsolationInfo.number == detachedResult.detachedInfo.number)
    }

}
