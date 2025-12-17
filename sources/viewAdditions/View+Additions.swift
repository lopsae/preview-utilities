//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension View {

    @inlinable public func maxWidthFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }


    @inlinable public func maxHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }


    @inlinable public func maxSizeFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }


    @inlinable public func frame(square side: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: side, height: side, alignment: alignment)
    }


    @inlinable public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }


    @inlinable public func roundedRectangleClip(cornerRadius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }


    /// Adds an action to be performed when a geometry proxy value changes.
    ///
    /// Convenience function for `View.onGeometryChange(for:of:action:)` allowing to infer the
    /// observed value with the given `keypath`.
    @inlinable public func onGeometryChange<T>(
        of keyPath: KeyPath<GeometryProxy, T> & Sendable,
        action: @escaping (_ newValue: T) -> Void
    ) -> some View
        where T : Equatable, T : Sendable
    {
        self.onGeometryChange(for: T.self, of: { $0[keyPath: keyPath] }, action: action)
    }


    @inlinable public func onGeometryChange<T>(
        of transform: @escaping @Sendable (GeometryProxy) -> T,
        binding: Binding<T>
    ) -> some View
        where T : Equatable, T : Sendable
    {
        self.onGeometryChange(
            for: T.self,
            of: transform,
            action: { binding.wrappedValue = $0 }
        )
    }


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
