//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Displays a sheet in a preview environment.
struct SheetPreview<Content>: View where Content: View {
    @Namespace var namespace
    @State var isSheetPresented: Bool = false
    let content: () -> Content

    let captionKey: LocalizedStringKey?

    init(
        _ captionKey: LocalizedStringKey? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.captionKey = captionKey
        self.content = content
    }

    var body: some View {
        let sheetTransitionId = "previewSheet.transtionId"
        VStack {
            if let captionKey {
                VStack(spacing: Defaults.padding/3) {
                    Image(systemName: "info.circle")
                    .imageScale(.large)
                    Text(captionKey)
                    .expandingWidthFrame()
                    .padding(.not(.top), Defaults.padding*1.5)
                }
                .maxWidthFrame()
                .background {
                    ConcentricRectangle(
                        uniformTopCorners: .concentric,
                        uniformBottomCorners: .concentric(minimum: .fixed(Defaults.padding))
                    )
                    .fill(.ultraThinMaterial)
                    .padding(Defaults.padding/2)
                    .ignoresSafeArea()
                }
            }

            Spacer()
        }
        .maxSizeFrame()
        .background {
            PrettyMesh.auroraEgg
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            Button("Show Sheet", constrainedSystemImage: "chevron.up") {
                isSheetPresented.toggle()
            }
            .labelStyle(BaselinedIconLabelStyle(length: 44))
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .matchedTransitionSource(id: sheetTransitionId, in: namespace)
        }
        .task {
            // Without this sleep, the sheet has issues (like displaying the wrong size) when
            // the preview refreshes.
            try? await Task.sleep(for: .seconds(0.5))
            isSheetPresented = true
        }
        .sheet(isPresented: $isSheetPresented) {
            content()
            .navigationTransition(.zoom(sourceID: sheetTransitionId, in: namespace))
        }
    }
}


// TODO: Brough from Trailing{Closure}, consider exposing or moving to its own package.
struct BaselinedIconLabelStyle: LabelStyle {
    let length: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "circle")
        .hidden()
        .overlay(alignment: .centerFirstTextBaseline) {
            configuration.icon
        }
        .contentShape(.circle)
        .frame(width: length, height: length)
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    struct ExampleView: View {
        var body: some View {
            CaptionRectangle("Example Preview", color: .orange, size: [200, 150])
            .presentationDetents([.medium, .large])
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: PreviewContent.layout) {
    SheetPreview {
        PreviewContent.ExampleView()
    }
}


#Preview("Captioned", traits: PreviewContent.layout) {
    SheetPreview("This is a caption that can be displayed behind the previewed sheet. _Formatted_ content is **supported**.") {
        PreviewContent.ExampleView()
    }
}


// MARK: - Non-Working Examples

// Attempting to create a preview trait to produce a SheetPreview did not worked. Below are examples
// of the implementations that had issues.


/// Content seems to be lost when the sheet is created by the preview trait itself.
private struct ContentLost_SheetWrapperPreviewModifier: PreviewModifier {
    @State var isSheetPresented: Bool = false

    func body(content: Content, context _: Void) -> some View {
        ClearRectangle()
        .background { PrettyMesh.auroraEgg.ignoresSafeArea() }
        .task {
            // Without this sleep, the sheet has issues (like displaying the wrong size) when
            // the preview refreshes.
            try? await Task.sleep(for: .seconds(0.5))
            isSheetPresented = true
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                Text("Above content")
                content
                Text("Below content")
            }
            .presentationDetents([.medium, .large])
        }
    }

}


#Preview("ContentLost", traits: .modifier(ContentLost_SheetWrapperPreviewModifier())) {
    CaptionRectangle("Example Preview", color: .orange, size: [200, 150])
}


// Simply wraps the content in a `SheetPreview`, content and detents are lost.
private struct SimpleSheetWrapperPreviewModifier: PreviewModifier {
    func body(content: Content, context _: Void) -> some View {
        SheetPreview("Simple") {
            content
        }
    }
}

#Preview("SimpleSheetWrapper", traits: .modifier(SimpleSheetWrapperPreviewModifier())) {
    PreviewContent.ExampleView()
}

// When content is just passed through the trait, the sheet does work...
private struct JustContentPreviewModifier: PreviewModifier {
    func body(content: Content, context _: Void) -> some View {
        content
    }
}

#Preview("JustContent", traits: .modifier(JustContentPreviewModifier())) {
    SheetPreview("Just Sheet") {
        PreviewContent.ExampleView()
    }
}


