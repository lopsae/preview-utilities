# Debug Overlay

@Metadata {
    @PageImage(purpose: card, source: "debug-overlay-card")
}


Visualize the boundaries, origin, and safe areas of a view, without impacting its layout.

Apply the ``DebugOverlayModifier`` using ``SwiftUICore/View/debugOverlay(_:)`` or any
[sibling function](doc:debug-overlay-api/View-Extensions) to overlay a visualization of the 
boundaries, origin, and safe areas:

![Visual components of the debug overlay.](debug-overlay-components)

The modifier can be configured by passing [`Trait`](doc:DebugOverlayModifier/Configuration/Trait) 
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
![Debug overlay using traits.](debug-overlay-simple-traits)


## Topics

### Modifier and Traits
+ ``DebugOverlayModifier``
+ ``DebugOverlayModifier/Configuration``
+ ``DebugOverlayModifier/Configuration/Trait``


### View Extensions
+ ``SwiftUICore/View/debugOverlay(_:)``
+ ``SwiftUICore/View/debugOverlay(traits:)``
