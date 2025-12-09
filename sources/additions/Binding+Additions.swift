//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Binding {

    /// Returns a binding that wrappes the caller and performs `action` on every set.
    func onSet(action: @escaping (Value) -> ()) -> Self {
        return .init {
            self.wrappedValue
        } set: { newValue in
            action(newValue)
            self.wrappedValue = newValue
        }
    }

}
