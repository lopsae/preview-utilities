# Floating Alignments

@Metadata {
    @PageImage(purpose: card, source: "floating-alignment-card")
}

Alignment positions for floating content.

Floating content is content overlaid an owner view and aligned to an edge of its boundaries, either
inside or outside. Since the content is overlaid, the layout of the owner view is never modified,
hence the content _floats_ over the owner view.

@Image(
    source: "floating-alignment-alignment-examples",
    alt: "Example floating alignments for inner top leading and outer bottom trailing"
) {
    Example floating alignments: _Outer Top Leading_ and _Inner Bottom Trailing_.
}

``FloatingAlignment`` identifies the available alignment positions for floating content. Use it on 
views that support floating content by building an instance, or using the available static 
properties like ``FloatingAlignment/outerTopLeading`` or ``FloatingAlignment/innerBottomTrailing``. 
See ``FloatingAlignment`` for the list of all convenience properties available.

Inner alignments identify the inner positions along the owner view. These work as equivalent to the 
SwiftUI alignments with the same names.

@Image(
    source: "floating-alignment-inner-alignments",
    alt: "Illustration of all inner floating alignments."
) {
    All inner alignments.
}

Outer alignments identify the outer positions along the owner view's boundaries, and are defined
through a major component (top, leading, bottom, and trailing) and a minor component (top, leading,
bottom, trailing, center, above, and under, depending on the major).

@Image(
    source: "floating-alignment-outer-alignments",
    alt: "Illustration of all outer floating alignments."
) {
    All outer alignments.
}



## Topics

### Inner and Outer Alignments

+ ``FloatingAlignment``
+ ``FloatingAlignment/InnerAlignment``
+ ``FloatingAlignment/OuterAlignment``


### Alignment Components
+ ``FloatingAlignment/HorizontalAlignment``
+ ``FloatingAlignment/VerticalAlignment``
+ ``FloatingAlignment/OuterVerticalAlignment``
