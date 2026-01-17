//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


nonisolated
protocol OptionSetTrait {
    associatedtype Option: OptionSetWithAll
    var operation: OptionSetTraitOperation<Option> { get }

    init(operation: OptionSetTraitOperation<Option>)
}


nonisolated
protocol OptionSetWithAll: OptionSet {
    static var all: Self { get }
}


nonisolated
enum OptionSetTraitOperation<Option: OptionSetWithAll> {
    case union(Option)
    case remove(Option)
}


nonisolated
extension OptionSetTrait {

    static func union(_ option: Option) -> Self {
        Self.init(operation: .union(option))
    }

    static func remove(_ option: Option) -> Self {
        Self.init(operation: .remove(option))
    }

    func apply(to options: Option) -> Option {
        switch operation {
        case .union(let traitOptions):
            return options.union(traitOptions)
        case .remove(let traitOptions):
            let inverse = traitOptions.symmetricDifference(.all)
            return options.intersection(inverse)
        }
    }

}


extension Sequence where Element: OptionSetTrait {
    func apply(to options: Element.Option) -> Element.Option {
        return self.reduce(options) { options, trait in
            trait.apply(to: options)
        }
    }
}
