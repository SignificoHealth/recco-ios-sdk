import Foundation
import SwiftUI

extension View {
    @available(iOS, obsoleted: 15.0, message: "SwiftUI.View.task is available on iOS 15.")
    @_disfavoredOverload
    func task(
        priority: _Concurrency.TaskPriority = .userInitiated,
        @_inheritActorContext _ action: @escaping @Sendable () async -> Swift.Void
    ) -> some SwiftUI.View {
        modifier(MyTaskModifier(priority: priority, action: action))
    }
}

struct MyTaskModifier: ViewModifier {
    private var priority: TaskPriority
    private var action: @Sendable () async -> Void

    init(
        priority: TaskPriority,
        action: @escaping @Sendable () async -> Void
    ) {
        self.priority = priority
        self.action = action
        self.task = nil
    }

    @State private var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .task(priority: priority, action)
        } else {
            content
                .onAppear {
                    self.task = Task {
                        await action()
                    }
                }
                .onDisappear {
                    self.task?.cancel()
                }
        }
    }
}
