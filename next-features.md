Next Features
=============

Possible new features for future versions.
+ Use FloatingCaption as the main text component in DebugOverlay.
+ Border element could be separated from floating caption, and used in cases where `.floatingCaption("", .colorStyle())` is used (just for the border).
+ Figure out vertical text views that comply with layouts.
+ Enable vertical texts in FloatingCaption and DebugOverlay.
+ Use SafeAreaPad for header and footers, add option to display safe area divider.


Library Separation
------------------
Many utilities here could be separated into their own packages.
+ Convenience Initializers for SwiftUI views: Slider, Picker.
+ Geometry utilities: additions to CGRect/Size/Point, future Angle utilities.
+ Utility layout vies/modifiers: TaskView, stackAbove/below.
