//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// Protocol to provide a `case` property, for enumerations with associated values, to simplify
/// the identification of each case.
nonisolated
public protocol IdentifiableCase {
    associatedtype Case: Hashable
    var `case`: Case { get }
}


extension Sequence where Element: IdentifiableCase {

    @inlinable nonisolated
    func containsCase(_ case: Element.Case) -> Bool {
        contains { $0.case == `case` }
    }

    @inlinable nonisolated
    func firstCase(_ case: Element.Case) -> Element? {
        first { $0.case == `case` }
    }

}


extension BidirectionalCollection where Element: IdentifiableCase {

    @inlinable nonisolated
    func lastCase(_ case: Element.Case) -> Element? {
        last { $0.case == `case` }
    }

}
