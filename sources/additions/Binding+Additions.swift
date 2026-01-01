//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Binding {

    /// Returns a binding that wrapps the caller and performs `action` on every set.
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
