//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


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
    public func expandingWidthFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxWidthFrame(height: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
            .frame(height: height, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func expandingHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxHeightFrame(width: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
            .frame(width: width, alignment: alignment)
    }


    @inlinable nonisolated
    public func maxSizeFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }


    @inlinable nonisolated
    public func expandingFrame(alignment: Alignment = .center) -> some View {
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


    @inlinable nonisolated
    func frame(length: CGFloat, along axis: Axis, alignment: Alignment = .center) -> some View {
        let width = axis == .horizontal ? length : nil
        let height = axis == .vertical ? length : nil
        return self.frame(width: width, height: height, alignment: alignment)
    }

    /// Expands the view's width with matching frame and multiline alignment.
    ///
    /// Applies the given multiline text alignment and wraps the view in a horizontally expanding
    /// frame with a matching alignment.
    ///
    /// When applied to `Text` views, allows the text to expand to the available width and remain
    /// aligned when displaying multiple lines.
    ///
    /// - Parameter textAlignment: The text alignment to apply to multiline text, and to the
    ///   expanding frame.
    public func expandingWidthFrame(textAlignment: TextAlignment) -> some View {
        self
        .multilineTextAlignment(textAlignment)
        .maxWidthFrame(
            alignment: textAlignment.horizontalAlignment.alignment(withOrthogonal: .center)
        )
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


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("ExpandingWidthText", traits: .spacing(8), .headerFooter, PreviewContent.layout) {
    Text("Single Line Default")
    .expandingWidthFrame()

    DashedDivider()

    Text("Single Line Trailing")
    .expandingWidthFrame(textAlignment: .trailing)

    DashedDivider()

    Text("Multiline text\nwith default alignment")
    .expandingWidthFrame()

    DashedDivider()

    Text("Multiline text\nwith center alignment")
    .expandingWidthFrame(textAlignment: .center)

    DashedDivider()

    Text("Multiline text\nwith trailing alignment")
    .expandingWidthFrame(textAlignment: .trailing)
}
