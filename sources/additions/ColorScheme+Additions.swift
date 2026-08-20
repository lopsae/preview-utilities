//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension ColorScheme {

    static var allCasesSet: Set<Self> { Set(Self.allCases) }

}


extension Set<ColorScheme> {

    static var all: Self { ColorScheme.allCasesSet }

}
