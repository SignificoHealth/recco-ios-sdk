import SwiftUI
import SFRepo
import SFResources

public enum SFErrorType {
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

public struct ErrorView: View {
    let error: Binding<Error?>
    let onRetry: (() -> Void)?
    let onClose: (() -> Void)?

    public init(error: Binding<Error?>, onRetry: (() -> Void)? = nil, onClose: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: .S) {
            if let wrappedError = error.wrappedValue {
                let sfError = SFErrorType(error: wrappedError)
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
                    SFButton(
                        style: .primary,
                        action: {
                            error.wrappedValue = nil
                            onRetry()
                        },
                        text: "error.reload".localized,
                        leadingImage: Image(resource: "reload_ic")
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(closeButtonIfNeeded(), alignment: .topTrailing)
    }

    @ViewBuilder private func closeButtonIfNeeded() -> some View {
        if let onClose = onClose {
            Button(action: onClose, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.sfPrimary)
            })
            .padding(.vertical, .M)
            .padding(.horizontal, .S)
        }
    }
}

extension View {
    @ViewBuilder
    public func errorView(
        error: Binding<Error?>,
        onRetry: (() -> Void)? = nil,
        onClose: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            if error.wrappedValue != nil {
                ErrorView(error: error, onRetry: onRetry, onClose: onClose)
            } else {
                self
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: error)
    }

    @ViewBuilder
    public func errorView(
        error: Binding<Error?>,
        onRetry: @escaping (@Sendable () async -> Void),
        onClose: (() -> Void)? = nil
    ) -> some View {
        errorView(error: error, onRetry: { _Concurrency.Task(operation: onRetry) }, onClose: onClose)
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
        ErrorView(
            error: .constant(NSError(domain: "", code: NSURLErrorNotConnectedToInternet)),
            onRetry: { print("Reload") }
        )
    }
}
