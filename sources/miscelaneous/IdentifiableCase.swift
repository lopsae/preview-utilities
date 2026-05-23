//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// Protocol that provides a `case` property to identify each case of an `Enum`
///
/// For enumerations with associated values, makes it possible to identify the case of an instance
/// with a simple equality operation.
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
