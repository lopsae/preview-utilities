//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct PathAdditionsSnapshots {

    /// Utility view to setup Paths based on a frame size, with a graticule drawn around.
    struct GraticuleRect<Content>: View where Content: View {
        @ViewBuilder var content: (CGFloat, CGRect) -> Content
        var body: some View {
            let heightSpacing: CGFloat = 8
            let frameSize: CGSize = [120, heightSpacing*3]
            ZStack {
                content(heightSpacing, frameSize.rect())
            }
            .frame(size: frameSize)
            .background(.gray.quinary)
            .edgeGraticule(spacing: 8)
        }
    }

    @Test(.snapshotTesting) func rect() {
        Snapshots.assertView("init") {
            VStack(spacing: 30) {
                GraticuleRect { spacing, frame in
                    let square: CGSize = .square(of: spacing*2)
                    Path(rect: CGRect(origin: .zero, size: square))
                    .stroke(.green)

                    Path(rect: CGRect(origin: [50, spacing], size: [spacing*3, spacing]))
                    .stroke(.green)
                }

                GraticuleRect { spacing, frame in
                    let square: CGSize = .square(of: spacing*2)
                    Path(rect: CGRect(origin: [-spacing, -spacing], size: square))
                    .stroke(.green)

                    Path(rect: CGRect(origin: [120, spacing * 2], size: square))
                    .stroke(.green)
                }
            }
        }
    }


    @Test(.snapshotTesting) func crosshair() {
        Snapshots.assertView("init") {
            VStack(spacing: 30) {
                GraticuleRect { spacing, frame in
                    Path(crosshair: .zero)
                    .stroke(.green)

                    Path(crosshair: frame.centerPoint)
                    .stroke(.green)

                    Path(crosshair: frame.maxPoint, length: spacing)
                    .stroke(.green)
                }

                GraticuleRect { spacing, frame in
                    Path(crosshair: [-spacing, -spacing])
                    .stroke(.green)

                    Path(crosshair: frame.maxPoint.adding(x: spacing, y: spacing), length: spacing*2)
                    .stroke(.green)
                }
            }
        }
    }

}
