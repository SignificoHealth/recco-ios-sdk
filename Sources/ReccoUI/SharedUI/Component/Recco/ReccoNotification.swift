import ReccoHeadless
import SwiftUI

extension View {
    func reccoNotification(
        error: Binding<Error?>,
        duration: Int = 2
    ) -> Self {
        if error.isPresent().wrappedValue {
            let data: ReccoNotificationData = .error(
                "recco_error_generic_title".localized,
                subtitle: "recco_error_generic_body".localized
            )

            UIApplication.shared.windows.first?
                .findOrCreateSharedNotificationView()
                .show(
                    style: data.style,
                    title: data.title,
                    subtitle: data.subtitle,
                    completion: {
                        error.wrappedValue = nil
                    }
                )
        }

        return self
    }

    func reccoNotification(
        data: Binding<ReccoNotificationData?>,
        duration: Int = 2
    ) -> Self {
        if data.isPresent().wrappedValue, let note = data.wrappedValue {
            UIApplication.shared.windows.first?
                .findOrCreateSharedNotificationView()
                .show(
                    style: note.style,
                    title: note.title,
                    subtitle: note.subtitle,
                    completion: {
                        data.wrappedValue = nil
                    }
                )
        }

        return self
    }
}

extension ReccoNotificationStyle {
    var imageName: String {
        switch self {
        case .error:
            return "error_x_mark_ic"
        case .confirmation:
            return "error_x_mark_ic"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .error:
            return .reccoBackground
        case .confirmation:
            return .reccoBackground
        }
    }

    var foreGroundColor: UIColor {
        switch self {
        case .error:
            return .reccoPrimary
        case .confirmation:
            return .reccoPrimary
        }
    }
}

final class SFNotificationView: UIView {
    fileprivate static let secretTag = 123781
    private var hideWorkItem: DispatchWorkItem?
    private var isShowing = false {
        didSet {
            isUserInteractionEnabled = isShowing
            container.isUserInteractionEnabled = isShowing
        }
    }
    private var topConstraint: NSLayoutConstraint!
    private let safeArea: UIEdgeInsets
    private var panGesture: UIPanGestureRecognizer!
    private var currentCompletion: () -> Void = {}
    private var currentDuration: Int = 3

    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .reccoBackground
        container.layer.cornerRadius = .XXS
        container.layer.shadowColor = UIColor.reccoOnBackground.cgColor
        container.layer.shadowOffset = .init(width: 0, height: 5)
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.15

        return container
    }()

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 32),
            image.heightAnchor.constraint(equalToConstant: 32),
        ])

        return image
    }()

    private lazy var hstack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = .S
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var vstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = .XXS / 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleLb: UILabel = {
        let titleLb = UILabel()
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        titleLb.textColor = .reccoPrimary
        titleLb.font = CurrentReccoStyle.font.uiFont(size: 16, weight: .semibold)
        titleLb.lineBreakMode = .byWordWrapping
        titleLb.numberOfLines = 2
        titleLb.setContentCompressionResistancePriority(.required, for: .vertical)
        return titleLb
    }()

    private lazy var subtitleLb: UILabel = {
        let subtitleLb = UILabel()
        subtitleLb.translatesAutoresizingMaskIntoConstraints = false
        subtitleLb.textColor = .reccoPrimary
        subtitleLb.font = CurrentReccoStyle.font.uiFont(size: 15, weight: .medium)
        subtitleLb.lineBreakMode = .byWordWrapping
        subtitleLb.numberOfLines = 2
        subtitleLb.setContentCompressionResistancePriority(.required, for: .vertical)
        return subtitleLb
    }()

    fileprivate init(insets: UIEdgeInsets) {
        self.safeArea = insets

        super.init(frame: .zero)

        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        layer.zPosition = 999
        tag = Self.secretTag
        backgroundColor = .clear

        hstack.addArrangedSubview(image)
        hstack.addArrangedSubview(vstack)
        vstack.addArrangedSubview(titleLb)
        vstack.addArrangedSubview(subtitleLb)

        container.addSubview(hstack)
        hstack.pinEdges(to: container, margin: .init(top: .S, left: .S, bottom: .S, right: .S))

        addSubview(container)
        topConstraint = container.topAnchor.constraint(equalTo: topAnchor, constant: -300)
        topConstraint.isActive = true

        NSLayoutConstraint.activate([
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.S),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .S),
        ])

        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))

        container.addGestureRecognizer(panGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addTo(window: UIWindow) {
        window.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
            heightAnchor.constraint(equalTo: container.heightAnchor, constant: .S + self.safeArea.top),
        ])
    }

    fileprivate func show(
        style: ReccoNotificationStyle = .confirmation,
        title: String,
        subtitle: String? = nil,
        duration: Int = 3,
        completion: @escaping () -> Void
    ) {
        currentCompletion = completion
        currentDuration = duration
        container.backgroundColor = style.backgroundColor
        titleLb.text = title
        titleLb.textColor = style.foreGroundColor
        subtitleLb.text = subtitle
        subtitleLb.textColor = style.foreGroundColor
        subtitleLb.isHidden = subtitle == nil
        image.image = UIImage(resource: style.imageName)?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .reccoPrimary

        if isShowing {
            hideWorkItem?.cancel()
        } else {
            isShowing = true
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.topConstraint.constant = .S + self.safeArea.top
                self.layoutIfNeeded()
            }
        }

        hide()
    }

    fileprivate func hide(now: Bool = false) {
        hideWorkItem = .init { [unowned self, weak hideWorkItem] in
            if hideWorkItem?.isCancelled ?? false { return }
            self.layoutIfNeeded()
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    self.topConstraint.constant = -300
                    self.layoutIfNeeded()
                },
                completion: { finished in
                    if finished {
                        self.isShowing = false
                        self.currentCompletion()
                    }
                }
            )
        }

        DispatchQueue.main.asyncAfter(deadline: !now ? .now() + .seconds(currentDuration) : .now(), execute: hideWorkItem!)
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: container)
        let dragVelocity = sender.velocity(in: container)

        switch sender.state {
        case .began:
            hideWorkItem?.cancel()
        case .changed:
            if translation.y > 50 { return }
            topConstraint.constant = .S + self.safeArea.top + translation.y
        case .cancelled, .ended:
            if dragVelocity.y <= -1300 {
                hide(now: true)
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.topConstraint.constant = .S + self.safeArea.top
                    self.layoutIfNeeded()
                }

                hide()
            }
        default:
			break
        }
    }
}

extension UIWindow {
    fileprivate func findOrCreateSharedNotificationView() -> SFNotificationView {
        if let noteView = viewWithTag(SFNotificationView.secretTag) as? SFNotificationView {
            return noteView
        } else {
            let noteView = SFNotificationView(insets: safeAreaInsets)
            noteView.addTo(window: self)
            return noteView
        }
    }

    func showHCNotification(
        title: String,
        subtitle: String? = nil,
        duration: Int = 3,
        completion: @escaping () -> Void
    ) {
        findOrCreateSharedNotificationView()
            .show(
                title: title,
                subtitle: subtitle,
                duration: duration,
                completion: completion
            )
    }
}
