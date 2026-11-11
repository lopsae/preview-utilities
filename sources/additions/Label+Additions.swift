//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Label {

    init(
        _ key: LocalizedStringKey,
        @ViewBuilder icon: () -> Icon
    ) where
        Title == Text
    {
        self.init(
            title: { Text(key) },
            icon: icon
        )
    }


    init(_ key: LocalizedStringKey, icon: Icon)
    where Title == Text
    {
        self.init(
            title: { Text(key) },
            icon: { icon }
        )
    }

}
