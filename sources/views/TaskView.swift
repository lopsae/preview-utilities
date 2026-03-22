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
struct TaskView<Result, Content>: View
where Result: Sendable, Content: View
{
    let taskBody: () async -> Result
    let content: (Result) -> Content

    @State var result: Result?

    init(
        // TODO: since this is a view, should this be isolated to main actor?
        @_inheritActorContext taskBody: @Sendable @escaping @isolated(any) () async -> Result,
        @ViewBuilder content: @escaping (Result) -> Content
    ) {
        self.taskBody = taskBody
        self.content = content
    }

    var body: some View {
        Group {
            if let result {
                content(result)
            } else {
                // A view is needed here for a view to exist in some cases to hold the task.
                // For example: inside stacks, `EmptyView` are removed, and the task never runs.
                // TODO: this can be the default, but another view could be provided instead?
                // TODO: add a preview showing that providing an EmptyView in a stack prevents the task from running.
                ClearRectangle(size: .zero)
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
                    print("in task")
                    return try! await generator.generateImage(with: "Task Image").image
                } content: { image in
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
        } content: { image in
            image
        }
    }

}
