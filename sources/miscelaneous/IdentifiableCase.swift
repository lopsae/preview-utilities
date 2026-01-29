//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//



nonisolated
protocol IdentifiableCase {
    associatedtype Case: Hashable
    var `case`: Case { get }
}


extension Sequence where Element: IdentifiableCase {

    func containsCase(_ case: Element.Case) -> Bool {
        contains { $0.case == `case` }
    }

    func firstCase(_ case: Element.Case) -> Element? {
        first { $0.case == `case` }
    }

}


extension BidirectionalCollection where Element: IdentifiableCase {

    func lastCase(_ case: Element.Case) -> Element? {
        last { $0.case == `case` }
    }

}
