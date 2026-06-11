# Floating Alignments

@Metadata {
    @PageImage(purpose: card, source: "floating-alignment-card")
}

Alignment positions for floating content.

Identifies the alignment positions for floating content over a parent view. Floating content is
content overlaid an owner view and aligned to an edge of its boundaries, either inside or
outside.

Inner alignments identify the inner positions along an owner view. These work as equivalent to the 
SwiftUI alignments with the same names.

@Image(
    source: "floating-alignment-inner-alignments",
    alt: "Illustration of all inner floating alignments."
) {
    All inner alignments.
}

Outer alignments identify the outer positions along an owners view's boundaries, and are defined
through a major component (top, leading, bottom, and trailing) and a minor component (top, leading,
bottom, trailing, center, above, and under, depending on the major).

@Image(
    source: "floating-alignment-outer-alignments",
    alt: "Illustration of all outer floating alignments."
) {
    All outer alignments.
}

See ``FloatingAlignment`` for the list of static properties available with all the
alignment permutations, like ``FloatingAlignment/outerLeadingTop`` or ``FloatingAlignment/outerTrailingUnder``.



## Topics

### Inner and Outer Alignments

+ ``FloatingAlignment``
+ ``FloatingAlignment/InnerAlignment``
+ ``FloatingAlignment/OuterAlignment``


### Alignment Components
+ ``FloatingAlignment/HorizontalAlignment``
+ ``FloatingAlignment/VerticalAlignment``
+ ``FloatingAlignment/OuterVerticalAlignment``
