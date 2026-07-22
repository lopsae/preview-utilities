Next Features
=============

For 0.4.1
---------
+ Finish DebugAlignmentGuide funtions, and document.
+ Create ApiCollection for ConfigurationModifier/Trait
+ Migrate DebugOverlay to also use ConfigurationModifierTrait


For 0.5.0
+ Rename DebugOverlay to DebugGeometry, to better match other possible debug modifiers.
+ Make alignment a parameter of FloatingCaption, CaptionRectangle, instead of a trait.

Possible new features for future versions.
+ Use FloatingCaption as the main text component in DebugOverlay.
+ Border element could be separated from floating caption, and used in cases where `.floatingCaption("", .colorStyle())` is used (just for the border).
+ Figure out vertical text views that comply with layouts.
+ Enable vertical texts in FloatingCaption and DebugOverlay.
+ Use SafeAreaPad for header and footers, add option to display safe area divider.
+ Reimplement FloatingContent to actually use the top/leading/bottom/trailing alingments to position its content.


Library Separation
------------------
Many utilities here could be separated into their own packages.
+ Convenience Initializers for SwiftUI views: Slider, Picker.
+ Geometry utilities: additions to CGRect/Size/Point, future Angle utilities.
+ Utility layout vies/modifiers: TaskView, stackAbove/below.
