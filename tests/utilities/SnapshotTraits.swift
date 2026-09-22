//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SnapshotTesting
import Testing


extension Trait where Self == _SnapshotsTestTrait {

    /// Configures snapshot testing to record all snapshots.
    ///
    /// Intended for new and updating tests.
    static var snapshotCapture: Self {
        .snapshots(record: .all)
    }

    /// Configures snapshot testing to never record new snapshots and use `ksdiff` for failure
    /// messages.
    ///
    /// Intended trait for committed tests.
    static var snapshotTesting: Self {
        .snapshots(record: .never, diffTool: .ksdiff)
    }

}
