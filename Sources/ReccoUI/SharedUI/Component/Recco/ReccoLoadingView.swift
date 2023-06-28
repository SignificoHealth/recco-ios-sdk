import SwiftUI

struct ReccoLoadingView<Content: View>: View {
    init(_ isLoading: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isLoading = isLoading
        self.content = content
    }
    
    var isLoading: Bool
    var content: () -> Content
    
    @ViewBuilder
    var body: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .reccoPrimary))
                .padding(.M)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            content()
        }
    }
}

struct ReccoLoadingUnwrappingView<Content: View, Wrapped>: View {
    init(
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
    var body: some View {
        Group {
            if let wrapped {
                content(wrapped)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .reccoPrimary))
                    .padding(.M)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .reccoErrorView(
            error: $error,
            onRetry: retry
        )
    }
}
