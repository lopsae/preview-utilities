//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: test if task body is able to modify state in its own view isolation, that is, to set state
// of the enclosing view!

/// Experimental view that starts a task when it appears, and displays the given content with the
/// task result when the task completes.
///
/// If the view is removed, the task is cancelled.
struct TaskView<Result, PendingContent, CompleteContent>: View
where Result: Sendable, PendingContent: View, CompleteContent: View
{
    let taskAction: () async -> Result
    let pendingContent: () -> PendingContent
    let completeContent: (Result) -> CompleteContent

    @State var result: Result?

    // TODO: initializer with default pendingView. Use ClearRectangle(size: .zero)
    init(
        // TODO: since this is a view, should this be isolated to main actor?
        @_inheritActorContext taskBody: @Sendable @escaping @isolated(any) () async -> Result,
        @ViewBuilder pending pendingContent: @escaping () -> PendingContent,
        @ViewBuilder complete completeContent: @escaping (Result) -> CompleteContent
    ) {
        self.taskAction = taskBody
        self.pendingContent = pendingContent
        self.completeContent = completeContent
    }

    var body: some View {
        Group {
            if let result {
                completeContent(result)
            } else {
                // Using `EmptyView` as the pending content has unexpected side effects when
                // contained in views like ZStack, which seem to discard `EmptyView`s.
                // See example previews.
                pendingContent()
            }
        }
        .task {
            result = await taskAction()
        }
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)

        TaskView {
            taskState = "Generating"
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1) ... .seconds(1.5))
            // TODO: use function that produces uiImage.
            let image = try! await generator.generateImage(with: "Task Image").image
            taskState = "Done"
            return image
        } pending: {
            ClearRectangle(size: .zero)
        } complete: { image in
            image
        }
    }
    Text(taskState)
}


#Preview("EmptyView+ZStack", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    PreviewCaption("""
        Some views like `ZStack` do a special treatment of `EmptyView`s removing them from the view
        hierachy.
        """)
    .paragraph("""
        In these cases the `.task` is also removed and never executes.
        """)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)

        TaskView {
            taskState = "Generating"
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1) ... .seconds(1.5))
            // TODO: use function that produces uiImage.
            let image = try! await generator.generateImage(with: "Task Image").image
            taskState = "Done"
            return image
        } pending: {
            EmptyView()
        } complete: { image in
            image
        }
    }
    Text(taskState)
}


#Preview("EmptyView+Overlay", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    PreviewCaption("""
        In other cases like using `.overlay` the `EmptyView` is not removed, and the task works
        normaly.
        """)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)
        .overlay {
            TaskView {
                taskState = "Generating"
                let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1) ... .seconds(1.5))
                // TODO: use function that produces uiImage.
                let image = try! await generator.generateImage(with: "Task Image").image
                taskState = "Done"
                return image
            } pending: {
                EmptyView()
            } complete: { image in
                image
            }
        }
    }
    Text(taskState)
}
