# Floating Caption

@Metadata {
    @PageImage(purpose: card, source: "cards-floating-caption")
}

Add a floating caption, border, and size information to any view, without impacting its layout.

Apply the ``FloatingCaptionModifier`` using ``SwiftUICore/View/floatingCaption(_:alignment:_:)`` or 
any [sibling function](doc:floating-caption-api#View-Extensions) to overlay a floating caption, and 
optionally draw a border over the owner view. The modifier can be configured by passing [`Trait`](doc:FloatingCaptionModifier/Trait)
instances:

```swift
Circle()
.fill(.tertiary)
.frame(width: 80, height: 80)
.floatingCaption(
    "A `Circle` Shape",             // caption localized string
    alignment: .outerLeadingBottom, // the caption alignment
    .height,                        // prints the height of the owner view
    .colorStyle(.indigo),           // sets the caption and border color
    .borderWidth(4)                 // sets the border width
)
```

![Floating caption with example traits and explanations.](floating-caption-readme-traits)


## Topics

### Modifier and Traits

+ ``FloatingCaptionModifier``
+ ``FloatingCaptionModifier/Trait``


### View Extensions

+ ``SwiftUICore/View/floatingCaption(_:alignment:_:)``
+ ``SwiftUICore/View/floatingCaption(verbatim:alignment:_:)``
+ ``SwiftUICore/View/floatingCaption(alignment:_:)``
+ ``SwiftUICore/View/floatingCaption(_:traits:)``
