//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Binding {

    // TODO: double check isolation, this could be non-isolated like afterSet.

    /// Returns a binding that wrapps the caller and performs `action` on every set.
    ///
    /// `action` is performed before relaying the new value to the wrapped binding.
    @MainActor
    func onSet(action: @escaping (Value) -> ()) -> Self {
        return .init {
            self.wrappedValue
        } set: { newValue in
            action(newValue)
            self.wrappedValue = newValue
        }
    }

}


extension Binding where Value: Sendable {

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
