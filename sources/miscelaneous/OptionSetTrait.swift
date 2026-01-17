//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


nonisolated
protocol OptionSetTrait {
    associatedtype Option: OptionSet
    var operation: OptionSetTraitOperation<Option> { get }

    init(operation: OptionSetTraitOperation<Option>)
}


// TODO: This is no longer needed for substraction. Still needed?
nonisolated
protocol OptionSetWithAll: OptionSet {
    static var all: Self { get }
}


nonisolated
enum OptionSetTraitOperation<Option: OptionSet> {
    case union(Option)
    case subtract(Option)
}


nonisolated
extension OptionSetTrait {

    static func union(_ option: Option) -> Self {
        Self.init(operation: .union(option))
    }

    static func subtract(_ option: Option) -> Self {
        Self.init(operation: .subtract(option))
    }

    func apply(to options: Option) -> Option {
        switch operation {
        case .union(let traitOption):
            return options.union(traitOption)
        case .subtract(let traitOption):
            return options.subtracting(traitOption)
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
