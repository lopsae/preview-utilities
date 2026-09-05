//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension ColorScheme {

    static var allCasesSet: Set<Self> { Set(Self.allCases) }

}


extension Set<ColorScheme> {

    /// A set with all values of `ColorScheme`.
    public static var all: Self { ColorScheme.allCasesSet }

}
