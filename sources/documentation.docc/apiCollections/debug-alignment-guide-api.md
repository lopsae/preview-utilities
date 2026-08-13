# Debug Alignment Guide

@Metadata {
    @PageImage(purpose: card, source: "cards-debug-alignment-guide")
}

Visualize the alignment guides of a view, without impacting its layout.

Apply the ``DebugAlignmentGuideModifier`` using ``SwiftUICore/View/debugAlignmentGuide(_:_:)`` to 
overlay a visualization of the alignment guides.

The modifier can be customized by passing [`Trait`](doc:DebugAlignmentGuideModifier/Trait) 
instances:

```swift
Text("A new age\ndoes not begin all of a sudden")
.font(.title)
.multilineTextAlignment(.trailing)
.debugAlignmentGuide(.trailingFirstTextBaseline,
    .lineWidth(8),
    .fixedLength(vertical: 200),
    .anchor(.trailing)
)
```
![Text displaying a trailing first text baseline alignment guide using example traits.](debug-alignment-guide-simple-traits)


## Single Axis Alignments

To visualize only a horizontal or vertical alignment guide, apply the ``DebugAxisAlignmentGuideModifier``
using ``SwiftUICore/View/debugAlignmentGuide(horizontal:_:)`` or ``SwiftUICore/View/debugAlignmentGuide(vertical:_:)``.

The modifier can be customized by passing ``DebugAxisAlignmentGuideModifier/Trait`` instances:

```swift
Text("Wisdom was passed on\nfrom mouth to mouth")
.font(.title)
.multilineTextAlignment(.center)
.debugAlignmentGuide(vertical: .lastTextBaseline,
    .lineWidth(8),
    .scaledLength(1.2)
)
```
![Text displaying a vertical last text baseline alignment guide using example traits.](debug-alignment-guide-simple-traits-single-axis)


## Topics

### Composite Modifier
+ ``DebugAlignmentGuideModifier``
+ ``DebugAlignmentGuideModifier/Configuration``


### Single Axis Modifier
+ ``DebugAxisAlignmentGuideModifier``
+ ``DebugVerticalAlignmentGuideModifier``
+ ``DebugHorizontalAlignmentGuideModifier``
+ ``DebugAxisAlignmentGuideConfigurationProtocol``
+ ``DebugAxisAlignmentGuideConfiguration``
+ ``DebugAxisAlignmentConfigurationLength``


### View Extensions
+ ``SwiftUICore/View/debugAlignmentGuide(_:_:)``
+ ``SwiftUICore/View/debugAlignmentGuide(horizontal:_:)``
+ ``SwiftUICore/View/debugAlignmentGuide(vertical:_:)``


### Traits
+ ``DebugAlignmentGuideModifier/Trait``
+ ``DebugAxisAlignmentGuideModifier/Trait``
