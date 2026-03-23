//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that starts a task when it appears, and displays the given content using the
/// task result when the it completes.
///
/// If the view is removed, the task is cancelled.
@MainActor
struct TaskView<Result, PendingContent, CompleteContent>: View
where Result: Sendable, PendingContent: View, CompleteContent: View
{
    let operation: () async -> Result
    let pendingContent: () -> PendingContent
    let completeContent: (Result) -> CompleteContent

    @State var result: Result?


    /// Creates a view that starts a task with the given operation, while the task is running
    /// `pendingContent` is displayed, and when the task completes the content is replaced with
    /// `completeContent`.
    init(
        operation: @escaping () async -> Result,
        @ViewBuilder pending pendingContent: @escaping () -> PendingContent,
        @ViewBuilder complete completeContent: @escaping (Result) -> CompleteContent
    ) {
        self.operation = operation
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
            result = await operation()
        }
    }
}


// MARK: Convenience initializers


extension TaskView {

    /// Creates a view that starts a task with the given operation, while the task is running a
    /// clear rectangle of size zero is displayed, and when the task completes the content is
    /// replaced with `completeContent`.
    init(
        operation: @escaping () async -> Result,
        @ViewBuilder complete completeContent: @escaping (Result) -> CompleteContent
    )
    where PendingContent == ClearRectangle<Color>
    {
        self.init(
            operation: operation,
            pending: { ClearRectangle(size: .zero) },
            complete: completeContent)
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
        } complete: { image in
            image
        }
    }
    Text(taskState)
}


#Preview("Pending", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    let imageSize: CGSize = .square(of: 150)
    TaskView {
        taskState = "Generating"
        let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1) ... .seconds(1.5))
        // TODO: use function that produces uiImage.
        let image = try! await generator.generateImage(with: "Task Image").image
        taskState = "Done"
        return image
    } pending: {
        CaptionRectangle("Pending", color: .green, size: imageSize)
    } complete: { image in
        image
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
