//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Foundation
import Testing


struct NumericAdditionTests {


    @Test func asInt() async throws {
        #expect(Int(55).asDouble == 55)

        #expect(Int8(55).asDouble == 55)
        #expect(Int16(55).asDouble == 55)
        #expect(Int32(55).asDouble == 55)
        #expect(Int64(55).asDouble == 55)
    }

    @Test func asDouble() async throws {
        // Marked as deprecated.
        // Double(55.7).asDouble
        // Float64(55.5).asDouble

        #expect(Float(55.5).asDouble == 55.5)
        #expect(Float16(55.5).asDouble == 55.5)
        #expect(Float32(55.5).asDouble == 55.5)

        #expect(CGFloat(55.5).asDouble == 55.5)
    }


    @Test func arithmeticRoundedInt() async throws {
        #expect(7.4.arithmeticRoundedInt == 7)
        #expect(7.5.arithmeticRoundedInt == 8)
        #expect(8.5.arithmeticRoundedInt == 8)
        #expect(8.6.arithmeticRoundedInt == 9)

        #expect(-7.4.arithmeticRoundedInt == -7)
        #expect(-7.5.arithmeticRoundedInt == -8)
        #expect(-8.5.arithmeticRoundedInt == -8)
        #expect(-8.6.arithmeticRoundedInt == -9)
    }


    @Test func stabilizedValue() async throws {
        #expect(7.0.stabilizedValue(5.9, threshold: 1) == 5.9)
        #expect(7.0.stabilizedValue(6.0, threshold: 1) == 6.0)
        #expect(7.0.stabilizedValue(6.1, threshold: 1) == 7.0)
        #expect(7.0.stabilizedValue(7.0, threshold: 1) == 7.0)
        #expect(7.0.stabilizedValue(7.9, threshold: 1) == 7.0)
        #expect(7.0.stabilizedValue(8.0, threshold: 1) == 8.0)
        #expect(7.0.stabilizedValue(8.1, threshold: 1) == 8.1)

        #expect((-7.0).stabilizedValue(-5.9, threshold: 1) == -5.9)
        #expect((-7.0).stabilizedValue(-6.0, threshold: 1) == -6.0)
        #expect((-7.0).stabilizedValue(-6.1, threshold: 1) == -7.0)
        #expect((-7.0).stabilizedValue(-7.0, threshold: 1) == -7.0)
        #expect((-7.0).stabilizedValue(-7.9, threshold: 1) == -7.0)
        #expect((-7.0).stabilizedValue(-8.0, threshold: 1) == -8.0)
        #expect((-7.0).stabilizedValue(-8.1, threshold: 1) == -8.1)

        // Zero always returns the new value.
        #expect(7.0.stabilizedValue(6.9, threshold: .zero) == 6.9)
        #expect(7.0.stabilizedValue(7.0, threshold: .zero) == 7.0)
        #expect(7.0.stabilizedValue(7.1, threshold: .zero) == 7.1)

        // Negative thresholds always return the new value.
        #expect(7.0.stabilizedValue(6.9, threshold: -1) == 6.9)
        #expect(7.0.stabilizedValue(7.0, threshold: -1) == 7.0)
        #expect(7.0.stabilizedValue(7.1, threshold: -1) == 7.1)
    }

}


