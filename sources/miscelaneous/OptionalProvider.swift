//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// Provider of an optional value.
///
/// `Optional` implements this protocol to allow protocol based type constrains for optionals.
protocol OptionalProvider {
    associatedtype Wrapped
    var optionalValue: Wrapped? { get }
}


/// Implementation of `OptionalProvider` to allow type constrains for optionals.
extension Optional: OptionalProvider {

    var optionalValue: Wrapped? {
        return self
    }

}
