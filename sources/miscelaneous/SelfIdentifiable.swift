//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// Experimental protocol that provides a default implementation of `Identifiable` by returning
/// itself.
///
/// - Note: Implementers of this protocol can still provide an implementation of any type to the
///     `id` property. In this case that custom implementation will take precedence over the default
///     implementation provided here, unless the instance is cast to `SelfIdentifiable`.
nonisolated
public protocol SelfIdentifiable: Identifiable, Hashable {

    /// The stable identity of the entity associated with this instance with the same type as the
    /// instance itself.
    var id: Self { get }

}


nonisolated
extension SelfIdentifiable {

    public var id: Self { self }

}
