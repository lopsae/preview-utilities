//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Displays a sheet in a preview environment.
struct SheetPreview<Content>: View where Content: View {
        @Namespace var namespace
        @State var isSheetPresented: Bool = true
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
                Button("Show Sheet", systemImage: "chevron.up") {
                    isSheetPresented = true
                }
                // TODO: Check button formatting.
//                .buttonStyle(.iconOnlyGlassReady)
//                .glassEffectInteractiveInCircle()
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

