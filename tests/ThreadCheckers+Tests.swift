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

        let currentThread = ThreadInfo.currentThreadNumber()
        // Test should be running in the Main thread.
        #expect(currentThread == 1)

        let concurrentThread = await threadChecker.concurrentThreadNumber()
        // Concurrent isolation should always send to a background thread.
        #expect(concurrentThread != 1)

        let nonisolatedThread = await threadChecker.nonisolatedThreadNumber()
        // Nonisolated should inherit the current isolation context: Main.
        #expect(nonisolatedThread == 1)

        let defaultIsolationThread = await threadChecker.defaultIsolationThreadNumber()
        // Default isolation should inherit the current isolation context: Main.
        #expect(defaultIsolationThread == 1)

        let detachedTask = Task.detached {
            let detachedThread = ThreadInfo.currentThreadNumber()
            // Detached task should run in a background thread.
            #expect(detachedThread != 1)

            let concurrentThread = await threadChecker.concurrentThreadNumber()
            // Concurrent isolation should run in a background thread.
            #expect(concurrentThread != 1)

            let nonisolatedThread = await threadChecker.nonisolatedThreadNumber()
            // Nonisolated should inherit the current isolation context.
            #expect(nonisolatedThread == detachedThread)

            let defaultIsolationThread = await threadChecker.defaultIsolationThreadNumber()
            // Default isolation should inherit the current isolation context.
            #expect(defaultIsolationThread == detachedThread)
        }
        #expect(await detachedTask.result.isSuccess)
    }

}
