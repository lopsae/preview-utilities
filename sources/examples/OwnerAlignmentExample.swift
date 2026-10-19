//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


private struct ContentView: View {
    var body: some View {
        VStack {
            Text("Overlays").font(.headline)
            
            Rectangle()
            .fill(.red.secondary)
            .frame(width: 100, height: 30)
            .overlay(alignment: .trailing) {
                Text("Manual Float")
                    .alignmentGuide(.trailing, computeValue: { dimension in
                        dimension[.leading]
                    })
            }
            
            Rectangle()
            .fill(.red.secondary)
            .frame(width: 100, height: 30)
            .alignmentGuide(.outerTrailing) { dimension in
                dimension[.trailing]
            }
            .overlay(alignment: Alignment(horizontal: .outerTrailing, vertical: .center)) {
                Text("OT-AG Float").fixedSize()
            }
            
            Rectangle()
            .fill(.green.secondary)
            .frame(width: 100, height: 30)
            .overlay(inOutAlignment: .outerTrailing) { 
                Text(" HIOA Float")
            }
            
            Divider()
            Text("VStacks").font(.headline)
            
            VStack(alignment: .outerTrailing) {
                Text("First")
                .alignmentGuide(.outerTrailing) { dimension in
                    dimension[.trailing]
                }
                Text("Second")
                .alignmentGuide(.outerTrailing) { dimension in
                    dimension[.trailing]
                }
                Text("Floating")
                Text("More Floating")
            }
            .border(.green.secondary, width: 2)
            
            VStack(alignment: HorizontalInnerOuterAlignment.outerTrailing.anchorAlignment) {
                Text("First")
                .alignmentGuide(innerOf: .outerTrailing)

                Text("Second")
                .alignmentGuide(innerOf: .outerTrailing)
                
                Text("HIOA Floating")
                Text("More Floating")
            }
            .border(.mint.secondary, width: 2)
            
            Divider()
            Text("Frames").font(.headline)
            
            Text("Manual Float")
            .alignmentGuide(.trailing) { dimension in
                dimension[.leading]
            }
            .frame(width: 150, height: 30, alignment: .trailing)
            .border(.red.secondary, width: 2)
            
            Text("OT-AG Float")
            .frame(width: 150, height: 30, alignment: .center(.leading))
            .border(.green.secondary, width: 2)
            .alignmentGuide(.outerTrailing) { $0[.outerTrailing] - 150 }
            .frame(width: 150, height: 30, alignment: .center(.outerTrailing))
            .border(.red.secondary, width: 4)
            
            Text("OT-AG+ Float")
            .alignmentGuide(.outerTrailing) { $0[.outerTrailing] - 10 }
            .frame(width: 150, height: 30, alignment: .center(.leading))
            .border(.green.secondary, width: 2)
            .alignmentGuide(.outerTrailing) { $0[.outerTrailing] - 150 }
            .frame(width: 150, height: 30, alignment: .center(.outerTrailing))
            .border(.red.secondary, width: 4)
            
            Text("HIOA Float")
            .frame(width: 150, heigth: 30, inOutAlignment: .outerTrailing)
            .border(.red.secondary, width: 4)
            
            Text("HIOA+ Float")
                .alignmentGuide(HorizontalInnerOuterAlignment.outerTrailing.anchorAlignment)  { $0[HorizontalInnerOuterAlignment.outerTrailing.anchorAlignment] - 10 }
            .frame(width: 150, heigth: 30, inOutAlignment: .outerTrailing)
            .border(.red.secondary, width: 4)
        } // VStack
    }
}

nonisolated
protocol InnerOuterAlignmentID: AlignmentID, Sendable {
    static var inner: HorizontalAlignment { get }
    static var outer: HorizontalAlignment { get }
}

nonisolated
struct OuterTrailing: InnerOuterAlignmentID {
    static let inner: HorizontalAlignment = .trailing
    static let outer: HorizontalAlignment = .leading
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        // TODO: could this be a typed function to make it more readable? and reduce chance of passing incorrect axis.
        context[outer]
    }
}

nonisolated
extension HorizontalAlignment {
    static let outerTrailing = HorizontalAlignment(OuterTrailing.self)
}

nonisolated
struct HorizontalInnerOuterAlignment: Sendable {
    let alignmentID: InnerOuterAlignmentID.Type
    let anchorAlignment: HorizontalAlignment
    
    init(_ alignmentID: InnerOuterAlignmentID.Type) {
        self.alignmentID = alignmentID
        // FIXME: almost sure this should be initialized with outer.
        self.anchorAlignment = .init(alignmentID)
    }
    
    static let outerTrailing = HorizontalInnerOuterAlignment(OuterTrailing.self) 
}

extension View {
    func alignmentGuide(innerOf inOutAlignment: HorizontalInnerOuterAlignment) -> some View {
        self.alignmentGuide(inOutAlignment.anchorAlignment) { dimension in
            dimension[inOutAlignment.alignmentID.inner]
        }
    }
}

extension View {
    func overlay(
        inOutAlignment: HorizontalInnerOuterAlignment,
        @ViewBuilder content: () -> some View
    ) -> some View {
        self
        .alignmentGuide(innerOf: inOutAlignment)
        .overlay(alignment: Alignment(horizontal: inOutAlignment.anchorAlignment, vertical: .center)) {
            content()
        }
    }
    
    func frame(
        width: CGFloat? = nil, 
        heigth: CGFloat? = nil, 
        inOutAlignment: HorizontalInnerOuterAlignment
    ) -> some View {
        let outerAlignment = HorizontalAlignment(inOutAlignment.alignmentID) 
        return self
        .frame(width: width, height: heigth, alignment: .center(.leading))
//        .border(.green.secondary, width: 2)
        .alignmentGuide(outerAlignment) { $0[outerAlignment] - (width ?? .zero) }
        .frame(width: 150, height: 30, alignment: .center(outerAlignment))
//        .border(.red.secondary, width: 4)
    }
}

extension Alignment {
    static func center(_ horizontalAlignment: HorizontalAlignment) -> Self {
        .init(horizontal: horizontalAlignment, vertical: .center)
    }
}


// MARK: - Previews


#Preview("Default") {
    ContentView()
}
