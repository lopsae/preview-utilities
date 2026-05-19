//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//

import DeveloperToolsSupport


/// Identifiers for image resources bundled in the module asset catalog.
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
