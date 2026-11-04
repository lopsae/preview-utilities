//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
struct PathShape: Shape {

    typealias PathProvider = @Sendable (_ rect: CGRect) -> Path
    typealias PathMutator = @Sendable (_ rect: CGRect, _ path: inout Path) -> Void

    let pathProvider: PathProvider

    init(pathProvider: @escaping PathProvider) {
        self.pathProvider = pathProvider
    }

    init(pathMutator: @escaping PathMutator) {
        self.pathProvider = { rect in
            var path = Path()
            pathMutator(rect, &path)
            return path
        }
    }

    func path(in rect: CGRect) -> Path { pathProvider(rect) }

}


#Preview("Default", traits: .paddingSpacing) {
    PathShape { rect in
        Paths.arrow(tip: rect.centerPoint, towards: .trailing, size: .square(of: 16))
    }
    .stroke(.red, lineWidth: 2)
    .frame(squareOf: 100)
    .floatingCaption("Path Provider", alignment: .outerBottomTrailing, .colorStyle(.yellow))

    DashedDivider()

    PathShape { rect, path in
        CGSize.square(of: 20).centered(in: rect).addToPath(&path) //.add(to: &path)
    }
    .stroke(.orange, lineWidth: 2)
    .frame(squareOf: 100)
    .floatingCaption("Path Mutator", alignment: .outerBottomTrailing, .colorStyle(.yellow))
}
