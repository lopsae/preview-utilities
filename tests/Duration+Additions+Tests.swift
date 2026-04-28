//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct DurationAdditionsTests {

    @Test func secondsRange() async throws {
        #expect(ClosedRange<Duration>.seconds(0...0) == Duration.seconds(0)...Duration.seconds(0))
        #expect(ClosedRange<Duration>.seconds(1...5) == Duration.seconds(1)...Duration.seconds(5))
    }

    @Test func randomDuration() async throws {
        let iterations: Int = 1000
        // Whole seconds
        for _ in 0 ..< iterations {
            let randomDuration: Duration = .random(in: .seconds(10) ... .seconds(100))
            #expect(randomDuration >= .seconds(10))
            #expect(randomDuration <= .seconds(100))
        }

        for _ in 0 ..< iterations {
            let durationRange: ClosedRange<Duration> = .seconds(0) ... .seconds(5)
            let randomDuration = durationRange.randomDuration()
            #expect(randomDuration >= .seconds(0))
            #expect(randomDuration <= .seconds(5))
        }

        // Only attoseconds.
        for _ in 0 ..< iterations {
            let randomDuration: Duration = .random(in: .init(attoseconds: 10) ... .init(attoseconds: 100))
            #expect(randomDuration >= .init(attoseconds: 10))
            #expect(randomDuration <= .init(attoseconds: 100))
        }

        for _ in 0 ..< iterations {
            let durationRange: ClosedRange<Duration> = .init(attoseconds: 0) ... .init(attoseconds: 5)
            let randomDuration = durationRange.randomDuration()
            #expect(randomDuration >= .init(attoseconds: 0))
            #expect(randomDuration <= .init(attoseconds: 5))
        }
    }


    @Test func randomDurationSingleValueRange() async throws {
        let iterations: Int = 1000
        // Whole seconds
        for _ in 0 ..< iterations {
            let randomDuration: Duration = .random(in: .seconds(55) ... .seconds(55))
            #expect(randomDuration == .seconds(55))
        }

        // Only attoseconds.
        for _ in 0 ..< iterations {
            let randomDuration: Duration = .random(in: .init(attoseconds: 77) ... .init(attoseconds: 77))
            #expect(randomDuration == .init(attoseconds: 77))
        }
    }

}
