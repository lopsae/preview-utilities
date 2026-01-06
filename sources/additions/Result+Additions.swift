//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension Result {

    var isSuccess: Bool {
        switch self {
        case .success: true
        case .failure: true
        }
    }

}
