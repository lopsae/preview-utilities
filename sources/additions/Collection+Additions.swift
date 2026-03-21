//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension Collection {

    public func index(startOffsetBy offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }


    public func distance(fromStartTo index: Index) -> Int {
        distance(from: startIndex, to: index)
    }


    public func clampDistance(_ distance: Int) -> Int? {
        let totalDistance = self.distance(fromStartTo: endIndex)
        let clampedDistance = distance.clamped(to: 0..<totalDistance)
        return clampedDistance
    }


    /// Reorders elements from row-major to column-major order for the given number of columns.
    ///
    /// When elements are displayed in a grid filling rows first (row-major order), this function
    /// reorders them so they appear to fill columns first (column-major order).
    ///
    /// Example:
    /// ```swift
    /// let array = [0, 1, 2, 3, 4]
    /// array.transposed(columns: 3)
    /// // returns [0, 2, 4, 1, 3]
    /// ```
    ///
    /// Original row-major layout:
    /// ```
    /// [0 1 2]
    /// [3 4  ]
    /// ```
    ///
    /// After reordering, elements display as:
    /// ```
    /// [0 2 4]
    /// [1 3  ]
    /// ```
    public func columnMajorReordered(columns: Int) -> [Element] {
        guard columns > 0, !isEmpty else { return Array(self) }
        let rows = (count + columns - 1) / columns
        var result: [Element] = []
        result.reserveCapacity(self.count)

        for row in 0..<rows {
            for col in 0..<columns {
                let indexDistance = col * rows + row
                let index = self.index(startOffsetBy: indexDistance)
                if self.indices.contains(index) {
                    result.append(self[index])
                }
            }
        }

        return result
    }

}

