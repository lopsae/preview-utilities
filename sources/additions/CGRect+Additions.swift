//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics
import SwiftUI


extension CGRect {

    @inlinable nonisolated
    public func setting(
        x newX: CGFloat? = nil,
        y newY: CGFloat? = nil,
        width newWidth: CGFloat? = nil,
        height newHeight: CGFloat? = nil
    ) -> Self {
        var mutableRect = self
        if let newX { mutableRect.origin.x = newX }
        if let newY { mutableRect.origin.y = newY }
        if let newWidth  { mutableRect.size.width  = newWidth }
        if let newHeight { mutableRect.size.height = newHeight }
        return mutableRect
    }


    @inlinable nonisolated
    public var center: CGPoint {
        size.toPoint
            .multiplying(by: 0.5)
            .offset(by: origin)
    }


    @inlinable nonisolated
    public func center(size: CGSize) -> Self {
        let centeredRect = CGRect(
            x: (self.width - size.width) / 2 + self.origin.x,
            y: (self.height - size.height) / 2 + self.origin.y,
            width: size.width,
            height: size.height
        )
        return centeredRect
    }


    @inlinable nonisolated
    public func offset(x: CGFloat = .zero, y: CGFloat = .zero) -> Self {
        self.offsetBy(dx: x, dy: y)
    }


    nonisolated
    func debugDescription<Style>(format: Style) -> String
    where Style: FormatStyle, Style.FormatInput == Double, Style.FormatOutput == String {
        let xString = origin.x.formatted(format)
        let yString = origin.y.formatted(format)
        let widthString  = size.width.formatted(format)
        let heightString = size.height.formatted(format)
        return "(\(xString), \(yString), \(widthString), \(heightString))"
    }

}


#if canImport(UIKit)

import UIKit

extension CGRect {

    @inlinable nonisolated
    func inset(by value: CGFloat) -> Self {
        inset(by: UIEdgeInsets.all(value))
    }

}

#endif


#if os(macOS)

extension CGRect {

    @inlinable nonisolated
    func inset(by value: CGFloat) -> Self {
        self.insetBy(dx: value, dy: value)
    }

}

#endif


// MARK: - Interactions with Path

extension CGRect {

    @discardableResult
    @inlinable nonisolated
    public func addTo(path: inout Path) -> Self {
        path.addRect(self)
        return self
    }

}
