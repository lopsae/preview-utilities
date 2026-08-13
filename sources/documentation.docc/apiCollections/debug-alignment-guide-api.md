# Debug Alignment Guide

@Metadata {
    @PageImage(purpose: card, source: "cards-debug-alignment-guide")
}

Visualize the alignment guides of a view, without impacting its layout.

Apply the ``DebugAlignmentGuideModifier`` using ``SwiftUICore/View/debugAlignmentGuide(_:_:)`` to 
overlay a visualization of the alignment guides.

The modifier can be customized by passing [`Trait`](doc:DebugAlignmentGuideModifier/Trait) 
instances.


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
