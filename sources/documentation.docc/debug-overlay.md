# Debug Overlay

@Metadata {
    @PageImage(purpose: card, source: "debug-overlay-card")
}


Visualize the boundaries, origin, and safe areas of any view, without impacting its layout.

Apply the ``DebugOverlayModifier`` using ``SwiftUICore/View/debugOverlay()``. A visualization of the
owner view's boundaries, origin, and safe areas is overlaid without impacting the original layout.
Optionally a text caption and additional geometry information can be included.

![Visual components of the debug overlay.](debug-overlay-components)

The overlay can be configured by passing [`Trait`](doc:DebugOverlayModifier/Configuration/Trait) 
instances to ``SwiftUICore/View/debugOverlay(_:)``:

```swift
Rectangle()
.fill(.yellow.gradient.secondary)
.frame(width: 200, height: 80)
.debugOverlay(
    .size,                     // prints the size of the parent view
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

+ ``SwiftUICore/View/debugOverlay()``
+ ``SwiftUICore/View/debugOverlay(_:)``
+ ``SwiftUICore/View/debugOverlay(traits:)``
