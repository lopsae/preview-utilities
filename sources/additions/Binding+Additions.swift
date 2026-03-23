//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Binding where Value: Sendable {

    /// Returns a binding that wrapps the caller and performs `action` before every set.
    ///
    /// `action` is performed before relaying the new value to the wrapped binding.
    nonisolated
    func onSet(action: @Sendable @escaping (Value) -> ()) -> Self {
        return .init {
            self.wrappedValue
        } set: { newValue in
            action(newValue)
            self.wrappedValue = newValue
        }
    }


    /// Returns a binding that wrapps the caller and performs `action` after every set.
    ///
    /// `action` is performed after relaying the new value to the wrapped binding.
    nonisolated
    func afterSet(action: @Sendable @escaping (Value) -> ()) -> Self {
        return .init {
            self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
            action(newValue)
        }
    }

}
