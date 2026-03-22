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
            }
        }
        .task {
            result = await taskBody()
        }
    }
}
