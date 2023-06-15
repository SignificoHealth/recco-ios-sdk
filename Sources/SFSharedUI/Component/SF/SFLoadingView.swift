import SwiftUI

public struct SFLoadingView<Content: View>: View {
    public init(_ isLoading: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isLoading = isLoading
        self.content = content
    }
    
    public var isLoading: Bool
    public var content: () -> Content
    
    @ViewBuilder
    public var body: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .sfPrimary))
                .padding(.M)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            content()
        }
    }
}

public struct SFLoadingUnwrappingView<Content: View, Wrapped>: View {
    public init(
        _ wrapped: Wrapped?,
        error: Binding<Error?>,
        retry: @escaping (@Sendable () async -> Void),
        @ViewBuilder content: @escaping (Wrapped) -> Content
    ) {
        self.wrapped = wrapped
        self._error = error
        self.content = content
        self.retry = retry
    }
    
    @Binding var error: Error?
    var wrapped: Wrapped?
    var content: (Wrapped) -> Content
    var retry: (@Sendable () async -> Void)

    @ViewBuilder
    public var body: some View {
        Group {
            if let wrapped {
                content(wrapped)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .sfPrimary))
                    .padding(.M)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sfErrorView(
            error: $error,
            onRetry: retry
        )
    }
}
