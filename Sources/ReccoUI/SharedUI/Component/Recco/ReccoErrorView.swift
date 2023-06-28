import SwiftUI

enum ReccoErrorType {
    case generic
    case noInternet

    init(error: Error) {
        self = (error.originalError as NSError).code == NSURLErrorNotConnectedToInternet ? .noInternet : .generic
    }

    var imageName: String {
        switch self {
        case .generic:
            return "no_conection_image"
        case .noInternet:
            return "no_conection_image"
        }
    }

    var title: String {
        switch self {
        case .generic:
            return "error.generic.title".localized
        case .noInternet:
            return "error.noInternet.title".localized
        }
    }

    var description: String {
        switch self {
        case .generic:
            return "error.generic.subtitle".localized
        case .noInternet:
            return "error.generic.subtitle".localized
        }
    }
}

struct ReccoErrorView: View {
    let error: Binding<Error?>
    let onRetry: (() -> Void)?
    let onClose: (() -> Void)?

    init(error: Binding<Error?>, onRetry: (() -> Void)? = nil, onClose: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
        self.onClose = onClose
    }

    var body: some View {
        VStack(spacing: .S) {
            if let wrappedError = error.wrappedValue {
                let sfError = ReccoErrorType(error: wrappedError)
                Image(resource: sfError.imageName)

                VStack(spacing: .XXS) {
                    Text(sfError.title)
                        .h4()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(sfError.description)
                        .body1()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let onRetry = onRetry {
                    ReccoButtonView(
                        style: .primary,
                        text: "error.reload".localized,
                        leadingImage: Image(resource: "reload_ic")
                    ) {
                        error.wrappedValue = nil
                        onRetry()
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(closeButtonIfNeeded(), alignment: .topTrailing)
        .background(Color.reccoBackground)
    }

    @ViewBuilder
    private func closeButtonIfNeeded() -> some View {
        if let onClose = onClose {
            Button(action: onClose, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.reccoPrimary)
            })
            .padding(.vertical, .M)
            .padding(.horizontal, .S)
        }
    }
}

extension View {
    @ViewBuilder
    func reccoErrorView(
        error: Binding<Error?>,
        onRetry: (() -> Void)? = nil,
        onClose: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            if error.wrappedValue != nil {
                ReccoErrorView(error: error, onRetry: onRetry, onClose: onClose)
            } else {
                self
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: error)
    }

    @ViewBuilder
    func reccoErrorView(
        error: Binding<Error?>,
        onRetry: @escaping (@Sendable () async -> Void),
        onClose: (() -> Void)? = nil
    ) -> some View {
        reccoErrorView(error: error, onRetry: { _Concurrency.Task(operation: onRetry) }, onClose: onClose)
    }
}

extension Binding: Equatable where Value == Error? {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let lhsError = lhs.wrappedValue as? NSError
        let rhsError = rhs.wrappedValue as? NSError
        return lhsError?.code == rhsError?.code && lhsError?.localizedDescription == rhsError?.localizedDescription
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ReccoErrorView(
            error: .constant(NSError(domain: "", code: NSURLErrorNotConnectedToInternet)),
            onRetry: { print("Reload") }
        )
    }
}
