//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: test if task body is able to modify state in its own view isolation, that is, to set state
// of the enclosing view!

/// Experimental view that performs a task when it appears and displays the given content
/// when the task produces a result.
///
/// If the view is removed, the task is cancelled.
struct TaskView<Result, AwaitContent, ResultContent>: View
where Result: Sendable, AwaitContent: View, ResultContent: View
{
    let taskBody: () async -> Result
    let awaitContent: () -> AwaitContent
    let resultContent: (Result) -> ResultContent

    @State var result: Result?

    init(
        // TODO: since this is a view, should this be isolated to main actor?
        @_inheritActorContext taskBody: @Sendable @escaping @isolated(any) () async -> Result,
        @ViewBuilder await awaitContent: @escaping () -> AwaitContent,
        @ViewBuilder result resultContent: @escaping (Result) -> ResultContent
    ) {
        self.taskBody = taskBody
        self.awaitContent = awaitContent
        self.resultContent = resultContent
    }

    var body: some View {
        Group {
            if let result {
                resultContent(result)
            } else {
                // A view is needed here for a view to exist in some cases to hold the task.
                // For example: inside stacks, `EmptyView` are removed, and the task never runs.
                // TODO: this can be the default, but another view could be provided instead?
                // TODO: add a preview showing that providing an EmptyView in a stack prevents the task from running.
//                ClearRectangle(size: .zero)
                awaitContent()
            }
        }
        .task {
            print("taskView.body.task")
            result = await taskBody()
        }
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)
            .overlay {
                TaskView {
                    let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(0.5) ... .seconds(1.5))
                    // TODO: use function that produces uiImage.
                    return try! await generator.generateImage(with: "Task Image").image
                } await: {
                    ClearRectangle(size: .zero)
                } result: { image in
                    image
                }
            }



    }

}


// TODO: why does it not seem to work when used in a zstack?
#Preview("ZStack", traits: .headerFooter, PreviewContent.layout) {
    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)

        TaskView {
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(0.5) ... .seconds(1.5))
            // TODO: use function that produces uiImage.
            print("in task")
            return try! await generator.generateImage(with: "Task Image").image
        } await: {
            ClearRectangle(size: .zero)
        } result: { image in
            image
        }
    }
}


// TODO: use padding spacing.
#Preview("EmptyView", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        Some views like `ZStack` do a special treatment of `EmptyView`s removing them from the view
        hierachy.
        """
    ).paragraph("""
        In these cases the `.task` is also removed and never executes.
        """)

    let imageSize: CGSize = .square(of: 150)
    ZStack {
        CaptionRectangle("Placeholder", color: .gray, size: imageSize)

        TaskView {
            let generator = ConcurrentImageGenerator(size: imageSize, sleepRange: .seconds(0.5) ... .seconds(1.5))
            // TODO: use function that produces uiImage.
            print("in task")
            return try! await generator.generateImage(with: "Task Image").image
        } await: {
            EmptyView()
        } result: { image in
            image
        }
    }
}
