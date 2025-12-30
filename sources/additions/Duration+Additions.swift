//
//  Duration+Additions.swift
//  PreviewUtilities
//
//  Created by Maic Lopez Saenz on 2025-12-30.
//


private let attosecondsPerSecond: Int128 = 1_000_000_000_000_000_000


extension Duration {

    /// Generates a random Duration within a specified closed range.
    /// - Parameter range: The range of durations to choose from.
    /// - Returns: A random Duration within the range.
    static func random(in range: ClosedRange<Duration>) -> Duration {
        // Contain seconds and attoseconds together using Int128.
        let lowerBoundAttoseconds = Int128(range.lowerBound.components.seconds) * attosecondsPerSecond + Int128(range.lowerBound.components.attoseconds)
        let upperBoundAttoseconds = Int128(range.upperBound.components.seconds) * attosecondsPerSecond + Int128(range.upperBound.components.attoseconds)

        let randomAttoseconds = Int128.random(in: lowerBoundAttoseconds...upperBoundAttoseconds)
        let secondsComponent = Int64(randomAttoseconds / attosecondsPerSecond)
        let attosecondsComponent = Int64(randomAttoseconds % attosecondsPerSecond)
        return Duration(
            secondsComponent: secondsComponent,
            attosecondsComponent: attosecondsComponent
        )
    }

}


extension ClosedRange where Bound == Duration {

    /// Returns a random duration within the range.
    func randomDuration() -> Duration {
        Duration.random(in: self)
    }

}
