//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct PathAdditionsSnapshots {

    @Test(.snapshotTesting) func rect() {
        Snapshots.assertView("init") {
            VStack(spacing: 20) {
                let frameSize: CGSize = [120, 20]

                Path(rect: CGRect(origin: .zero, size: .square(of: 20)))
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(rect: CGRect(origin: [50, 5], size: [20, 10]))
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(rect: CGRect(origin: [-10, -10], size: .square(of: 10)))
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(rect: CGRect(origin: [120, 10], size: .square(of: 10)))
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)
            }
        }
    }


    @Test(.snapshotTesting) func crosshair() {
        Snapshots.assertView("init") {
            VStack(spacing: 20) {
                let frameSize: CGSize = [120, 20]

                Path(crosshair: .zero)
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(crosshair: [60, 10], length: 10)
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(crosshair: [-5, -5], length: 10)
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)

                Path(crosshair: [130, 10])
                .stroke(.green)
                .frame(size: frameSize)
                .border(.gray.secondary)
            }
        }
    }

}
