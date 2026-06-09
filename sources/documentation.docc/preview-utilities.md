# ``PreviewUtilities``

@Options {
    @TopicsVisualStyle(detailedGrid)
}

Utilities for SwiftUI previews.

## Overview

A collection of modifiers, views, extensions, and other utilities useful for building
previews in SwiftUI.

## Topics

### Debug Overlay

Visualize the boundaries, origin, and safe areas of any view, without impacting its layout.

+ ``DebugOverlayModifier``
+ ``DebugOverlayModifier/Configuration``
+ ``DebugOverlayModifier/Configuration/Trait``
+ ``SwiftUICore/View/debugOverlay()``
+ ``SwiftUICore/View/debugOverlay(_:)``
+ ``SwiftUICore/View/debugOverlay(traits:)``



### Floating Caption

Add a floating caption, border, and size information to any view, without impacting its layout.

+ ``FloatingCaptionModifier``
+ ``FloatingCaptionModifier/Trait``
+ ``SwiftUICore/View/floatingCaption(_:_:)``
+ ``SwiftUICore/View/floatingCaption(_:traits:)``



### Floating Alignment

+ ``FloatingAlignment``


### Format Styles

+ ``IdentityFormatStyle``
+ ``FirstCharacterFormatStyle``
+ ``CapitalizedFormatStyle``
+ ``RawValueFormatStyle``
+ ``StringDescriptionFormatStyle``
+ ``PropertyFormatStyle``
+ ``CompositeFormatStyle``
