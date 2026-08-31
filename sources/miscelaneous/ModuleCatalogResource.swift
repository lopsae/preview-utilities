//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//

import DeveloperToolsSupport


/// Identifiers for image resources bundled in the module asset catalog.
///
/// Use these identifiers and `ImageResource/moduleCatalog(_:)` to access the assets in the package
/// asset catalog, instead of using the convenience accessors provided by Xcode.
///
/// When the package is build outside of Xcode, (E.g. using `swift build` in console) the
/// convenience accessors in ImageResource for assets in the asset catalog are NOT available and
/// the build will fail. These convenience accessors are only generated through Xcode.
enum ModuleCatalogResource: String {
    case envelopeOffcenterBadgeTopTrailing    = "custom.envelope.offcenter.badge.top.trailing"
    case envelopeOffcenterBadgeBottomTrailing = "custom.envelope.offcenter.badge.bottom.trailing"

    var name: String { rawValue }
}


extension ImageResource {

    static func moduleCatalog(_ resource: ModuleCatalogResource) -> Self {
        .init(name: resource.name, bundle: .module)
    }

}
