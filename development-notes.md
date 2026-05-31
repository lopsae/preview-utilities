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


Run package tests, note this runs all tests included in the package test target:
```zsh
swift test
```


To run an specific testplan, use `xcodebuild` instead: 
```zsh
xcodebuild test \
    -scheme PreviewUtilities \
    -testPlan UnitTests \
    -destination 'platform=iOS Simulator,OS=26.4.1,name=iPhone 17 Pro'
```


To see the available destinations for testing:
```zsh
xcodebuild -scheme PreviewUtilities -showdestinations
```



Documentation generation
------------------------

Build the documentation archive (`PreviewUtilities.doccarchive`):
```zsh
swift package generate-documentation
```

Preview documentation in a local server:
```zsh
swift package --disable-sandbox preview-documentation
``` 
