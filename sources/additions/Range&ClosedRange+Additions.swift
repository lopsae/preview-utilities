//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension Range where Bound: Strideable {

    // strides from lowerBound to upperBound, not including upperBound
    func stride(by stride: Bound.Stride) -> StrideTo<Bound> {
        Swift.stride(from: lowerBound, to: upperBound, by: stride)
    }

}


extension ClosedRange where Bound: Strideable {

    // strides from lowerBound to upperBound, including upperBound
    func stride(by stride: Bound.Stride) -> StrideThrough<Bound> {
        Swift.stride(from: lowerBound, through: upperBound, by: stride)
    }

}
