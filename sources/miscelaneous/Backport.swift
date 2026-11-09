//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


// Inspired by https://swiftwithmajid.com/2026/09/22/backporting-swiftui-apis/

/// Instance namespace for features only available after an specific version.
///
/// Add a `backport: Backport<Self>` property to a type and add an extension to that constrained
/// backport to provide access to features only available at specific OS versions.
struct Backport<Content> {
    let content: Content
    init(_ content: Content) {
        self.content = content
    }
}


/// Availability and value of a backported property.
///
/// Allows to report the availability and value of a backported property.
enum BackportProperty<Property> {
    case available(Property)
    case unavailable

    var value: Property? {
        switch self {
        case .available(let property): property
        case .unavailable: nil
        }
    }
}


// FIXME: Maybe rename OptionalProvider?
/// Provider of an optional value.
///
/// Optional implements this protocol to allow protocol based type constrains for optionals.
protocol OptionalProtocol {
    associatedtype Wrapped
    var optionalValue: Wrapped? { get }
}


/// Implementation of `OptionalProtocol` to allow type constrains for optionals.
extension Optional: OptionalProtocol {

    var optionalValue: Wrapped? {
        return self
    }

}


extension BackportProperty where Property: OptionalProtocol {

    var unwrappedValue: Property.Wrapped? {
        switch self {
        case .available(let optional):
            switch optional.optionalValue {
            case .some(let value): return value
            case .none: return nil
            }
        case .unavailable: return nil
        }
    }

}
