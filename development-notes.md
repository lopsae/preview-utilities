Development Notes
=================

Notes through the development process.


`swift` Command Line
--------------------

The `swift` command should always run from the root of the package, at the same level of
`Package.swift`.


Build the package:
```zsh
swift build
```

Build the documentation archive (`PreviewUtilities.doccarchive`):
```zsh
swift package generate-documentation
```

Preview documentation in a local server:
```zsh
swift package --disable-sandbox preview-documentation
``` 
