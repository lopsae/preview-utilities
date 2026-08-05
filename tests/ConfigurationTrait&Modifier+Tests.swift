//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct ConfigurationTraitTests {

    struct DummyConfiguration: TraitInitializable {
        var flag: Bool = false
        var value: Int = .zero
        init() {}
    }

    struct SetValue: ConfigurationModifier {
        let value: Int
        func update(configuration: inout DummyConfiguration) {
            configuration.value = value
        }
    }


    @Test func initializationWithNoTraits() async throws {
        let configuration = DummyConfiguration(traits: [])
        #expect(configuration.flag == false)
        #expect(configuration.value == .zero)
    }


    @Test func mutateAppliesClosure() {
        var configuration = DummyConfiguration()
        let trait: ConfigurationTrait<DummyConfiguration> = .mutate { $0.value = 57 }

        trait.apply(to: &configuration)
        #expect(configuration.value == 57)
    }


    @Test func modifierAppliesUpdate() {
        var configuration = DummyConfiguration()
        let trait: ConfigurationTrait<DummyConfiguration> = .modifier(SetValue(value: 57))

        trait.apply(to: &configuration)
        #expect(configuration.value == 57)
    }


    @Test func traitsApplyInOrder() {
        var configuration = DummyConfiguration()
        let trait: ConfigurationTrait<DummyConfiguration> = .traits([
            .mutate { $0.value = 5 },
            .mutate { $0.value = 7 }
        ])

        trait.apply(to: &configuration)
        #expect(configuration.value == 7)
    }


    /// Test that the result of the first trait carries into the second trait.
    @Test func configurationCarryBetweenTraits() {
        var configuration = DummyConfiguration()
        let trait: ConfigurationTrait<DummyConfiguration> = .traits([
            .mutate { $0.value += 5 },
            .mutate { $0.value += 7 }
        ])

        trait.apply(to: &configuration)
        #expect(configuration.value == 12)
    }


    @Test func arrayLiteralWrapsTraits() {
        var configuration = DummyConfiguration()
        let trait: ConfigurationTrait<DummyConfiguration> = [
            .mutate { $0.flag = true },
            .mutate { $0.value = 57 }
        ]

        trait.apply(to: &configuration)
        #expect(configuration.flag == true)
        #expect(configuration.value == 57)
    }


    @Test func applyTraitsMixesModifierAndMutate() {
        var configuration = DummyConfiguration()

        configuration.apply(traits: [
            .mutate { $0.flag = true },
            .modifier(SetValue(value: 57))
        ])

        #expect(configuration.flag == true)
        #expect(configuration.value == 57)
    }


    @Test func initFromTraitsStartsFromDefault() {
        let configuration = DummyConfiguration(traits: [
            .mutate { $0.flag = true }
        ])

        #expect(configuration.flag == true)
        #expect(configuration.value == 0)
    }

}
