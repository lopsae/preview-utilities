//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// MARK: Frame Extensions


extension View {

    @inlinable nonisolated
    public func maxWidthFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxSizeFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func frame(squareOf length: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: length, height: length, alignment: alignment)
    }


    @available(*, deprecated, renamed: "frame(squareOf:)")
    @inlinable nonisolated
    public func frame(square side: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: side, height: side, alignment: alignment)
    }


    @inlinable nonisolated
    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }

}


// MARK: Rectangles Extensions


extension View {

    @inlinable nonisolated
    public func roundedRectangleClip(cornerRadius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

}


// MARK: GeometryChange Extensions


extension View {

    /// Adds an action to be performed when a geometry proxy value changes.
    ///
    /// Convenience function for `View.onGeometryChange(for:of:action:)` that infers the type of
    /// the observed value from a given `keypath`.
    ///
    /// This function propagates ALL changes of the observed property to `action`. Use with caution.
    @inlinable
    public func onGeometryChange<Property>(
        keyPath: KeyPath<GeometryProxy, Property> & Sendable,
        action: @escaping (_ newValue: Property) -> Void
    ) -> some View
    where Property : Equatable & Sendable
    {
        self.onGeometryChange(for: Property.self, of: { $0[keyPath: keyPath] }, action: action)
    }


    /// Updates a binding when a geometry proxy value changes.
    ///
    /// Convenience function for `View.onGeometryChange(for:of:action:)` that infers the type of
    /// the observed value from a given `keypath` and updates a binding directly.
    ///
    /// This function propagates ALL changes of the observed property to `binding`. Use with caution.
    @inlinable
    public func onGeometryChange<Property>(
        keyPath: KeyPath<GeometryProxy, Property> & Sendable,
        binding: Binding<Property>,
    ) -> some View
    where Property: Equatable & Sendable
    {
        self.onGeometryChange(
            keyPath: keyPath,
            action: { binding.wrappedValue = $0 }
        )
    }


    /// Adds an action to be performed when a value, created from a geometry proxy property,
    /// changes.
    ///
    /// Convenience function for `View.onGeometryChange(for:of:action:)` that infers the type of
    /// the observed value from a given `keypath`.
    @inlinable
    public func onGeometryChange<Property, Result>(
        keyPath: KeyPath<GeometryProxy, Property> & Sendable,
        transform: @Sendable @escaping (Property) -> Result,
        action: @escaping (_ newValue: Result) -> Void
    ) -> some View
    where
    Property : Equatable & Sendable,
    Result: Equatable & Sendable
    {
        self.onGeometryChange(for: Result.self, of: { geometryProxy in
            let value = geometryProxy[keyPath: keyPath]
            let result = transform(value)
            return result
        }, action: action)
    }


    /// Updates a binding when a value, created from a geometry proxy property, changes.
    ///
    /// Convenience function for `View.onGeometryChange(for:of:action:)` that infers the type of
    /// the observed value from a given `keypath` and updates a binding directly.
    @inlinable
    public func onGeometryChange<Property, Result>(
        keyPath: KeyPath<GeometryProxy, Property> & Sendable,
        binding: Binding<Result>,
        transform: @Sendable @escaping (Property) -> Result
    ) -> some View
    where
    Property : Equatable & Sendable,
    Result: Equatable & Sendable
    {
        self.onGeometryChange(
            keyPath: keyPath,
            transform: transform,
            action: { binding.wrappedValue = $0 }
        )
    }


    // TODO: deprecate? since keypath sendability was figured out
    @inlinable
    public func onGeometryChange<T>(
        of transform: @escaping @Sendable (GeometryProxy) -> T,
        binding: Binding<T>
    ) -> some View
    where T : Equatable & Sendable
    {
        self.onGeometryChange(
            for: T.self,
            of: transform,
            action: { binding.wrappedValue = $0 }
        )
    }

}


// MARK: ScrollView Extensions


extension View {

    @inlinable public func contentMargins(
        _ insets: EdgeInsets,
        for placement: ContentMarginPlacement = .automatic
    ) -> some View {
        self.contentMargins(.all, insets, for: placement)
    }


    @inlinable public func onScrollGeometryChange<T>(
        of keyPath: KeyPath<ScrollGeometry, T>,
        binding: Binding<T>
    ) -> some View
        where T : Equatable, T : Sendable
    {
        self.onScrollGeometryChange(
            for: T.self,
            of: { $0[keyPath: keyPath] },
            action: { binding.wrappedValue = $1 }
        )
    }

}
