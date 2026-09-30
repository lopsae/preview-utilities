Next Features
=============


For 0.5.0
---------
+ Migrate DebugOverlay to also use ConfigurationModifierTrait
+ Rename DebugOverlay to DebugGeometry, to better match other possible debug modifiers.
+ Make alignment a parameter of FloatingCaption, CaptionRectangle, instead of a trait.
+ DocumentationIllustration -> Illustration? SnippetIllustration?

For future versions
-------------------
+ Use FloatingCaption as the main text component in DebugOverlay.
+ Figure out vertical text views that comply with layouts.
+ Enable vertical texts in FloatingCaption and DebugOverlay.
+ Use SafeAreaPad for header and footers, add option to display safe area divider.
+ Reimplement FloatingContent to actually use the top/leading/bottom/trailing alingments to position its content.


Library Separation
------------------
Many utilities here could be separated into their own packages.
+ Convenience Initializers for SwiftUI views: Slider, Picker.
+ Utility layout vies/modifiers: TaskView, stackAbove/below.
