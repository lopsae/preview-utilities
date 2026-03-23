//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that starts a task when it appears and when the task completes displays the
/// given content using the result.
///
/// The task is scheduled using the `.task` view modifier, if the view is removed while the task is
/// still executing, the task is cancelled.
@MainActor
public struct TaskView<Result, PendingContent, CompletedContent>: View
where Result: Sendable, PendingContent: View, CompletedContent: View
{
    let operation: () async -> Result
    let pendingContent: () -> PendingContent
    let completedContent: (Result) -> CompletedContent

    @State var result: Result?


    /// Creates a view that starts a task with the given operation, while the task is running
    /// `pendingContent` is displayed, and when the task completes the content is replaced with
    /// `completedContent`.
    public init(
        operation: @escaping () async -> Result,
        @ViewBuilder pending pendingContent: @escaping () -> PendingContent,
        @ViewBuilder completed completedContent: @escaping (Result) -> CompletedContent
    ) {
        self.operation = operation
        self.pendingContent = pendingContent
        self.completedContent = completedContent
    }

    public var body: some View {
        Group {
            if let result {
                completedContent(result)
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
    /// replaced with `completedContent`.
    public init(
        operation: @escaping () async -> Result,
        @ViewBuilder complete completedContent: @escaping (Result) -> CompletedContent
    )
    where PendingContent == ClearRectangle<Color>
    {
        self.init(
            operation: operation,
            pending: { ClearRectangle(size: .zero) },
            completed: completedContent)
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

    Text(taskState)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize, traits: .alignment(.top))

        TaskView {
            taskState = "Generating"
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1...1.5))
            let platformImage = try! await generator.generatePlatformImage(with: "Task Image").platformImage
            taskState = "Done"
            return platformImage
        } complete: { platformImage in
            Image(platformImage: platformImage)
        }
        .debugOverlay(.caption("TaskView"), .size, .infoAlignment(.outerBottomTrailing))
    }
}


#Preview("Pending", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    Text(taskState)

    let imageSize: CGSize = .square(of: 150)
    TaskView {
        taskState = "Generating"
        let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1...1.5))
        let platformImage = try! await generator.generatePlatformImage(with: "Task Image").platformImage
        taskState = "Done"
        return platformImage
    } pending: {
        CaptionRectangle("Pending\nContent", color: .green, size: imageSize)
    } completed: { platformImage in
        Image(platformImage: platformImage)
    }
}


#Preview("EmptyView+ZStack", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    PreviewCaption("""
        **Using `EmptyView` as the pending content may remove the view and its attached task.**
        """)
    .paragraph("""
        Some views like `ZStack` do a special treatment of `EmptyView`s removing them from the view
        hierachy. In these cases the `.task` is also removed and never executes.
        """)

    Text(taskState)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)

        TaskView {
            taskState = "Generating"
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1...1.5))
            let platformImage = try! await generator.generatePlatformImage(with: "Task Image").platformImage
            taskState = "Done"
            return platformImage
        } pending: {
            EmptyView()
        } completed: { platformImage in
            Image(platformImage: platformImage)
        }
    }
}


#Preview("EmptyView+Overlay", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    @Previewable @State var taskState: String = "Idle"

    PreviewCaption("""
        In other cases like using `.overlay` the `EmptyView` is not removed, and the task works
        normaly.
        """)

    Text(taskState)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)
        .overlay {
            TaskView {
                taskState = "Generating"
                let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(1...1.5))
                let platformImage = try! await generator.generatePlatformImage(with: "Task Image").platformImage
                taskState = "Done"
                return platformImage
            } pending: {
                EmptyView()
            } completed: { platformImage in
                Image(platformImage: platformImage)
            }
        }
    }
}
