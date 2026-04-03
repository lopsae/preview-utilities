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
        // TODO: HStack(collection...)
        HStack {
            ForEach(0...9, id: \.self) { index in
                CaptionRectangle("Item \(index)", color: .pink, size: .square(of: 100))
            }
        }
    }
    .onScrollGeometryChange(of: \.contentOffset.x, binding: $contentOffset)
    .onScrollGeometryChange(of: \.visibleRect, binding: $visibleRect)

    Text("Content Offset: \(contentOffset, format: .fractionLength(2))")
        .monospacedDigit()
    Text("Visible Rect: \(visibleRect.debugDescription(format: .fractionLength(2)))")
        .monospacedDigit()
}


// TODO: move to extension

extension CGRect {

    func debugDescription<Style>(format: Style) -> String where Style: FormatStyle, Style.FormatInput == Double, Style.FormatOutput == String {
        let xString = origin.x.formatted(format)
        let yString = origin.y.formatted(format)
        let widthString  = size.width.formatted(format)
        let heightString = size.height.formatted(format)
        return "(\(xString), \(yString), \(widthString), \(heightString))"
    }

}


#Preview("GeometryChanges+Transforms", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var scrollableWidth: CGFloat = 0
    @Previewable @State var scrollRatio: CGFloat = 0
    @Previewable @State var contentWidth: CGFloat = 0
    @Previewable @State var containerWidth: CGFloat = 0

    PreviewCaption("""
        `onScrollGeometryChange` also has options to transform a value, or to perform an action.
        """)

    ScrollView(.horizontal) {
        // TODO: HStack(collection...)
        HStack {
            ForEach(0...9, id: \.self) { index in
                CaptionRectangle("Item \(index)", color: .pink, size: .square(of: 100))
            }
        }
    }
    // TODO: use geometry change with transform to produce containerWidth.
    .onScrollGeometryChange(of: \.contentSize.width, binding: $contentWidth)
    .onScrollGeometryChange(of: \.containerSize.width, binding: $containerWidth)
    .onScrollGeometryChange(for: Double.self) { geometry in
        geometry.contentOffset.x
    } action: { oldValue, newValue in
        let scrollableWidth = (contentWidth - containerWidth)
        guard scrollableWidth > 0 else { return }
        scrollRatio = newValue / scrollableWidth
    }

    Text("Scroll Ratio: \(scrollRatio, format: .fractionLength(2))")
        .monospacedDigit()
}
