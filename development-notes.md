Development Notes
=================

Notes through the development process.


`swift` Command Line
--------------------

The `swift` command should always run from the root of the package, at the same level of
`Package.swift`.

To build the package:
```zsh
swift build
```


To build the documentation archive (`PreviewUtilities.doccarchive`):
```zsh
swift package generate-documentation
```
