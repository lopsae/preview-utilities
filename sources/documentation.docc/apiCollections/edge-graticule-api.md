# Edge Graticule

@Metadata {
    @PageImage(purpose: card, source: "edge-graticule-card")
}


Overlay a graticule based on the edges of a view, without impacting its layout.

Apply the ``EdgeGraticuleModifier`` using ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any
[sibling function](doc:edge-graticule-api/View-Extensions) to overlay a graticule based on the 
edges of the owner view. The graticule consists of sets of lines evenly spaced for each of the edges 
of the owner view, both inset and outset:

![Inset components of the edge graticule.](edge-graticule-inset-components)

![Outset components of the edge graticule.](edge-graticule-outset-components)


The modifier can be customized by passing [`Trait`](doc:EdgeGraticuleModifier/Trait) 
instances:

```swift
Capsule()
.fill(.cyan.gradient.secondary)
.frame(width: 200, height: 60)
.edgeGraticule(
    spacing: 16,
    // Modifies the spacing and count for bottom inset lines.
    .inset(.bottom, spacing: 8, count: 3),
    // Modifies the count for horizontal outset lines.
    .outset(.horizontal, count: 2)
)
```
![Edge graticule overlaid on a capsule shape, showing a customized graticule built from trait examples.](edge-graticule-simple-traits)

## Topics

### Modifier
+ ``EdgeGraticuleModifier``
+ ``EdgeGraticuleModifier/Configuration``


### View Extensions
+ ``SwiftUICore/View/edgeGraticule(spacing:_:)``
+ ``SwiftUICore/View/edgeGraticule(insetSpacing:insetCount:outsetSpacing:outsetCount:_:)``


### Traits
+ ``EdgeGraticuleModifier/Trait``
+ ``ConfigurationTrait/inset(_:spacing:count:)``
+ ``ConfigurationTrait/outset(_:spacing:count:)``
+ ``ConfigurationTrait/straddle(_:spacing:count:)``


### Views
+ ``EdgeGraticule``
