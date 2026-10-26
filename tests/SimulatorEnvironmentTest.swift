//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Testing

#if canImport(UIKit)
import UIKit
#endif


enum TestEnvironment {
    /// Description of the device and OS running the current test process.
    @MainActor
    static var description: String {
        let environment = ProcessInfo.processInfo.environment
        // Set by the simulator; nil when running on a real device or on macOS.
        let simulatorName = environment["SIMULATOR_DEVICE_NAME"]        // "iPhone 17 Pro"
        let simulatorModel = environment["SIMULATOR_MODEL_IDENTIFIER"]  // "iPhone18,1"
        let simulatorRuntime = environment["SIMULATOR_RUNTIME_VERSION"] // "27.0"

        #if canImport(UIKit)
        let os = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        #else
        let os = "macOS \(ProcessInfo.processInfo.operatingSystemVersionString)"
        #endif

        return """
            OS: \(os)
            Simulator: \(simulatorName ?? "none") \
            (\(simulatorModel ?? "Unknown model"), runtime \(simulatorRuntime ?? "Unknown runtime"))
            """
    }
}

struct SimulatorEnvironmentTest {

    /// Snapshot tests are expected to run in a specific simulator and operating system.
    ///
    /// Visual elements like fonts and spacing may differ in different environment.
    @Test func simulatorEnvironment() {
        #expect(TestEnvironment.description == """
            OS: iOS 26.5
            Simulator: iPhone 17 Pro (iPhone18,1, runtime 26.5)
            """)
    }

}
