# Edge Graticule

<!-- FIXME: Implement card. -->


Overlay a graticule based on the edges of the owner view, without impacting its layout.

Apply the ``EdgeGraticuleModifier`` using ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any
[sibling function](doc:edge-graticule-api/View-Extensions) to overlay a graticule based on the 
edges of the owner view.

<!--
// FIXME: Implement component image.
![Visual components of the debug overlay.](debug-overlay-components)
-->

The modifier can be customized by passing [`Trait`](doc:EdgeGraticuleModifier/Trait) 
instances:

```swift
Text("Sphinx\nof Black\nQuartz")
.font(.title)
.edgeGraticule(
    spacing: 20,
    // modifies the spacing and count for bottom inset lines.
    .inset(.bottom, spacing: 15, count: 2),
    // Modifies the count for horizontal outset lines.
    .outset(.horizontal, count: 3),
)
```

<!--
// FIXME: Implement trait example image.
![Debug overlay using traits.](debug-overlay-simple-traits)
-->

## Topics

### Modifier
+ ``EdgeGraticuleModifier``
+ ``EdgeGraticuleModifier/Configuration``


### View Extensions
+ ``SwiftUICore/View/edgeGraticule(spacing:_:)``
+ ``SwiftUICore/View/edgeGraticule(insetSpacing:through:_:)``
+ ``SwiftUICore/View/edgeGraticule(outsetSpacing:through:_:)``
+ ``SwiftUICore/View/edgeGraticule(insetSpacing:outsetSpacing:_:)``
+ ``SwiftUICore/View/edgeGraticule(insetSpacing:through:outsetSpacing:through:_:)``


### Traits
+ ``EdgeGraticuleModifier/Trait``
+ ``ConfigurationTrait/inset(_:spacing:count:)``
+ ``ConfigurationTrait/outset(_:spacing:count:)``
+ ``ConfigurationTrait/straddle(_:spacing:count:)``


### Views
+ ``EdgeGraticule``
