Next Features
=============


For 0.5.5
---------
+ Fleshout `HorizontalRelativeAlignment`, publicize `FloatingAlignedContainer` if still useful.

For 0.5.4
---------
+ DocumentationIllustration -> Illustration? SnippetIllustration?


For 0.5.3
---------
+ Migrate DebugOverlay to also use ConfigurationModifierTrait
+ Add explicit trait parameter label to DebugGeometry and FloatingCaption.


For 0.5.2
---------
+ Add container shape capabilities to debugGeometry. 


For future versions
-------------------
+ Update CaptionRectangle to use its own traits, instead of FloatingCaption traits, also expose alignment as a parameter.
+ Use FloatingCaption as the main text component in DebugOverlay.
+ Figure out vertical text views that comply with layouts.
+ Enable vertical texts in FloatingCaption and DebugGeometry.
+ Use SafeAreaPad for header and footers, add option to display safe area divider.
+ Reimplement FloatingContent to actually use the top/leading/bottom/trailing alingments to position its content.
+ Add FloatingCaption color parameter, that activates both caption and border style, and add `traits` parameter labels.


Library Separation
------------------
Many utilities here could be separated into their own packages.
+ Convenience Initializers for SwiftUI views: Slider, Picker.
+ Utility layout vies/modifiers: TaskView, stackAbove/below.
