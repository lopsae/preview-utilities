# Debug Alignment Guide

@Metadata {
    @PageImage(purpose: card, source: "cards-debug-alignment-guide")
}

Visualize the alignment guides of any view, without impacting its layout.

Apply the ``DebugAlignmentGuideModifier`` using ``SwiftUICore/View/debugAlignmentGuide(_:_:)`` or any
[sibling function](doc:debug-alignment-guide-api/View-Extensions) to overlay a visualization of the
alignment guides.

The modifier can be customized by passing [`Trait`](doc:DebugAlignmentGuideModifier/Trait) 
instances.


## Topics

### Modifier
+ ``DebugAlignmentGuideModifier``
+ ``DebugAlignmentGuideModifier/Configuration``
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


### Composite Traits
+ ``DebugAlignmentGuideModifier/Trait``


### Axis Traits
+ ``DebugAxisAlignmentGuideModifier/Trait``
