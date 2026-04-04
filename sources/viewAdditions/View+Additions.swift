//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// MARK: Frame Extensions


extension View {

    @inlinable nonisolated
    public func minSizeFrame(alignment: Alignment = .center) -> some View {
        self.frame(minWidth: .zero, minHeight: .zero)
    }

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

    /// Adds an action to be performed when a geometry property changes.
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


    /// Updates a binding when a geometry property changes.
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


    /// Adds an action to be performed when a value, created from a geometry property, changes.
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
        Property: Equatable & Sendable, // TODO: might not need equatable.
        Result: Equatable & Sendable
    {
        self.onGeometryChange(for: Result.self, of: { geometryProxy in
            let value = geometryProxy[keyPath: keyPath]
            let result = transform(value)
            return result
        }, action: action)
    }


    /// Updates a binding when a value, created from a geometry property, changes.
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
        Property: Equatable & Sendable, // TODO: might not need equatable.
        Result: Equatable & Sendable
    {
        self.onGeometryChange(
            keyPath: keyPath,
            transform: transform,
            action: { binding.wrappedValue = $0 }
        )
    }

}


// MARK: ScrollView Extensions


extension View {

    @inlinable
    public func contentMargins(
        _ insets: EdgeInsets,
        for placement: ContentMarginPlacement = .automatic
    ) -> some View {
        self.contentMargins(.all, insets, for: placement)
    }


    /// Adds an action to be performed when a scroll geometry property changes.
    ///
    /// Convenience function for `View.onScrollGeometryChange(for:of:action:)` that infers the type
    /// of the observed value from a given `keypath`.
    ///
    /// This function propagates ALL changes of the observed property to `action`. Use with caution.
    @inlinable
    public func onScrollGeometryChange<Property: Equatable>(
        of keyPath: KeyPath<ScrollGeometry, Property>,
        action: @escaping (_ oldValue: Property, _ newValue: Property) -> Void
    ) -> some View {
        self.onScrollGeometryChange(for: Property.self, of: { $0[keyPath: keyPath] }, action: action)
    }


    /// Updates a binding when a scroll geometry property changes.
    ///
    /// Convenience function for `View.onScrollGeometryChange(for:of:action:)` that infers the type
    /// of the observed value from a given `keypath` and updates a binding directly.
    ///
    /// This function propagates ALL changes of the observed property to `binding`. Use with caution.
    @inlinable
    public func onScrollGeometryChange<Property: Equatable>(
        of keyPath: KeyPath<ScrollGeometry, Property>,
        binding: Binding<Property>
    ) -> some View {
        self.onScrollGeometryChange(
            of: keyPath,
            action: { oldValue, newValue in binding.wrappedValue = newValue }
        )
    }


    /// Adds an action to be performed when a value, created from a scroll geometry property,
    /// changes.
    ///
    /// Convenience function for `View.onScrollGeometryChange(for:of:action:)` that infers the type
    /// of the observed value from a given `keypath`.
    @inlinable
    public func onScrollGeometryChange<Property, Result: Equatable>(
        of keyPath: KeyPath<ScrollGeometry, Property>,
        transform: @Sendable @escaping (Property) -> Result,
        action: @escaping (_ oldValue: Result, _ newValue: Result) -> Void
    ) -> some View {
        self.onScrollGeometryChange(for: Result.self, of: { geometry in
            let value = geometry[keyPath: keyPath]
            let result = transform(value)
            return result
        }, action: action)
    }


    /// Updates a binding when a value, created from a scroll geometry property, changes.
    ///
    /// Convenience function for `View.onScrollGeometryChange(for:of:action:)` that infers the type
    /// of the observed value from a given `keypath` and updates a binding directly.
    @inlinable
    public func onScrollGeometryChange<Property, Result: Equatable>(
        of keyPath: KeyPath<ScrollGeometry, Property>,
        binding: Binding<Result>,
        transform: @Sendable @escaping (Property) -> Result
    ) -> some View {
        self.onScrollGeometryChange(
            of: keyPath,
            transform: transform,
            action: { oldValue, newValue in binding.wrappedValue = newValue }
        )
    }

}


// TODO: move on geometry additions and previews to its own file.


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("GeometryChanges+Binding", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var contentOffset: CGFloat = 0
    @Previewable @State var visibleRect: CGRect = .zero

    PreviewCaption("""
        `onScrollGeometryChange(of:binding:)` can forward all changes to a scroll geometry property to a
        binding.
        """)

    ScrollView(.horizontal) {
        HStack(0...9, id: \.self) { index in
            CaptionRectangle("Item \(index)", color: .pink, size: .square(of: 100))
        }
    }
    .onScrollGeometryChange(of: \.contentOffset.x, binding: $contentOffset)
    .onScrollGeometryChange(of: \.visibleRect, binding: $visibleRect)

    Text("Content Offset: \(contentOffset, format: .fractionLength(2))")
        .monospacedDigit()
    Text("Visible Rect: \(visibleRect.debugDescription(format: .fractionLength(2)))")
        .monospacedDigit()
}


#Preview("GeometryChanges+Transforms", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var scrollableWidth: CGFloat = 0
    @Previewable @State var scrollRatio: CGFloat = 0

    PreviewCaption("""
        `onScrollGeometryChange` also has options to transform a value, or to perform an action.
        """)

    ScrollView(.horizontal) {
        HStack(0...9, id: \.self) { index in
            CaptionRectangle("Item \(index)", color: .pink, size: .square(of: 100))
        }
    }
    .onScrollGeometryChange(of: \.self, binding: $scrollableWidth) { geometry in
        geometry.contentSize.width - geometry.containerSize.width
    }
    .onScrollGeometryChange(for: Double.self) { geometry in
        geometry.contentOffset.x
    } action: { oldValue, newValue in
        guard scrollableWidth > 0 else { return }
        scrollRatio = newValue / scrollableWidth
    }

    Text("Scroll Ratio: \(scrollRatio, format: .fractionLength(2))")
        .monospacedDigit()
    Text("Scrollable Width: \(scrollableWidth, format: .fractionLength(2))")
        .monospacedDigit()
}
