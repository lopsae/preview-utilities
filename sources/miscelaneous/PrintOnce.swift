//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental observable object to print a log message during the first request of views.
///
/// Call `print()` within a view body to print `mesage` the first time it is called. This is
/// currently the best know way to print a message consistently at the begining of a preview.
///
/// Internally `Swift.print` is used, instead of `Logger`, since logger sadly does not get
/// displayed in Xcode console for previews.
@Observable
public class PrintOnce {

    let message: String
    private(set) var hasPrinted: Bool = false


    init(_ message: String) {
        self.message = message
    }


    /// Prints `message` the only the first time it is called, always returns `EmptyView`.
    public func print() -> EmptyView {
        if !hasPrinted {
            hasPrinted = true
            Swift.print(message)
        }
        return EmptyView()
    }


    public static var previewStarted: PrintOnce {
        .init("✴️ Preview started")
    }

}


// MARK: - Previews


#Preview(traits: .iPhoneProSizeLayout) {
    @Previewable let printOnce: PrintOnce = .previewStarted

    // Only known way to print ahead, but this prints on every call to body.
    let _ = print("⚠️ Print before printOnce")
    printOnce.print()

    Text("printOnce.hasPrinted: \(printOnce.hasPrinted.description)")
        .monospaced()
    StarShape(points: 9, concaveVertexRatio: 0.5)
    .fill(.purple)
    .onAppear {
        print("onAppear called")
    }
    .task {
        print("task called")
    }
    .onChange(of: printOnce.hasPrinted) { oldValue, newValue in
        // Does not get called since the first change ocurrs during the initial view construction.
        print("hasPrinted changed: \(newValue)")
    }

}
