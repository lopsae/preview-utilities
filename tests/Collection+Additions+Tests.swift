//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct CollectionAdditionsTests {

    @Test func subscriptModulo() {
        let array: [String] = ["zero", "one", "two", "three", "four"]

        #expect(array[modulo: 0] == "zero")
        #expect(array[modulo: 1] == "one")
        #expect(array[modulo: 4] == "four")

        #expect(array[modulo: 5] == "zero")
        #expect(array[modulo: 7] == "two")
        #expect(array[modulo: 9] == "four")

        #expect(array[modulo: 100] == "zero")
        #expect(array[modulo: 103] == "three")
        #expect(array[modulo: 104] == "four")
    }


    @Test func offsetAndDistanceFromStart() {
        let array: [String] = ["zero", "one", "two", "three", "four"]

        let indexOffsetByZero = array.index(startOffsetBy: 0)
        let indexOffsetByTwo  = array.index(startOffsetBy: 2)
        let indexOffsetByFour = array.index(startOffsetBy: 4)
        let indexOffsetByTen  = array.index(startOffsetBy: 10)

        #expect(indexOffsetByZero == 0)
        #expect(indexOffsetByTwo  == 2)
        #expect(indexOffsetByFour == 4)
        #expect(indexOffsetByTen  == 10)

        #expect(array.distance(fromStartTo: indexOffsetByZero) == 0)
        #expect(array.distance(fromStartTo: indexOffsetByTwo)  == 2)
        #expect(array.distance(fromStartTo: indexOffsetByFour) == 4)
        #expect(array.distance(fromStartTo: indexOffsetByTen)  == 10)
    }


    /// Uses an array slice with offset indices.
    @Test func offsetAndDistanceFromStartWithSlice() {
        let slice = Strings.natoPhoneticAlphabet[5..<10]

        let indexOffsetByZero = slice.index(startOffsetBy: 0)
        let indexOffsetByTwo  = slice.index(startOffsetBy: 2)
        let indexOffsetByFour = slice.index(startOffsetBy: 4)
        let indexOffsetByTen  = slice.index(startOffsetBy: 10)

        #expect(indexOffsetByZero == 5)
        #expect(indexOffsetByTwo  == 7)
        #expect(indexOffsetByFour == 9)
        #expect(indexOffsetByTen  == 15)

        #expect(slice.distance(fromStartTo: indexOffsetByZero) == 0)
        #expect(slice.distance(fromStartTo: indexOffsetByTwo)  == 2)
        #expect(slice.distance(fromStartTo: indexOffsetByFour) == 4)
        #expect(slice.distance(fromStartTo: indexOffsetByTen)  == 10)
    }

}
