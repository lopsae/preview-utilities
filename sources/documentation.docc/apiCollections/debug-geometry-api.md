# Debug Geometry

@Metadata {
    @PageImage(purpose: card, source: "debug-geometry-card")
}


Visualize the boundaries, origin, and safe areas of a view, without impacting its layout.

Apply the ``DebugGeometryModifier`` using ``SwiftUICore/View/debugGeometry(_:)`` or any
[sibling function](doc:debug-geometry-api#View-Extensions) to overlay a visualization of the 
boundaries, origin, and safe areas:

![Visual components of the debug overlay.](debug-geometry-components)

The modifier can be configured by passing [`Trait`](doc:DebugGeometryModifier/Configuration/Trait) 
instances:

```swift
Rectangle()
.fill(.yellow.gradient.secondary)
.frame(width: 200, height: 80)
.debugOverlay(
    .size,                     // prints the size of the owner view
    .bordersWidth(2),          // sets debug borders width to 2
    .alignment(.innerTrailing) // aligns caption to trailing-center
)
```
![Debug overlay using traits.](debug-geometry-simple-traits)


## Topics

### Modifier and Traits
+ ``DebugGeometryModifier``
+ ``DebugGeometryModifier/Configuration``
+ ``DebugGeometryModifier/Configuration/Trait``


### View Extensions
+ ``SwiftUICore/View/debugGeometry(_:)``
+ ``SwiftUICore/View/debugGeometry(traits:)``
