# Edge Graticule

@Metadata {
    @PageImage(purpose: card, source: "edge-graticule-card")
}


Overlay a graticule based on the edges of the owner view, without impacting its layout.

Apply the ``EdgeGraticuleModifier`` using ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any
[sibling function](doc:edge-graticule-api/View-Extensions) to overlay a graticule based on the 
edges of the owner view. The graticule consist of sets of lines evenly spaced for each of the edges 
of the owner view, both inset and outset:

![Visual components of the edge graticule.](edge-graticule-components)

The number of lines and spacing can be configured for each edge, and for
each direction. For example, the graticule above is produced with the following code:

```swift
RoundedRectangle(cornerRadius: 16)
.fill(.teal.gradient.secondary)
.frame(width: 140, height: 100)
.edgeGraticule(
    insetSpacing: 8, outsetSpacing: 16,
    .inset(.top, spacing: 8*3),
    .inset(.bottom, count: 3)
)
```

The modifier can be customized by passing [`Trait`](doc:EdgeGraticuleModifier/Trait) 
instances:

```swift
Capsule()
.fill(.cyan.gradient.secondary)
.frame(width: 200, height: 60)
.edgeGraticule(
    spacing: 20,
    // modifies the spacing and count for bottom inset lines.
    .inset(.vertical, spacing: 10, count: 2),
    // Modifies the count for horizontal outset lines.
    .outset(.horizontal, count: 3)
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
