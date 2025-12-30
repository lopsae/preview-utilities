//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif


extension NSParagraphStyle {

    @inlinable nonisolated
    public static func make(
        mutate: (NSMutableParagraphStyle) -> Void
    ) -> NSParagraphStyle {
        let mutable = NSMutableParagraphStyle(mutate: mutate)
        return mutable
    }

}


extension NSMutableParagraphStyle {

    @inlinable nonisolated
    public convenience init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }

}
