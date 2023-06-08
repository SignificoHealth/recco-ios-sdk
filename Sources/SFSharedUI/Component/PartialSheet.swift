//
//  PartialSheet.swift
//
//
//  Created by Adrián R on 27/7/22.
//

import Foundation
import SFResources
import SwiftUI
import UIKit

public struct PaddingTopView<Content: View>: View {
    var content: Content
    var paddingTop: CGFloat
    
    public var body: some View {
        content
            .padding(.top, paddingTop)
    }
}

public enum SheetSize {
    case extraLarge
    case large
    case medium
    case small
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .extraLarge:
            return UIScreen.main.bounds.height * 0.9
        case .large:
            return UIScreen.main.bounds.height * 0.75
        case .medium:
            return UIScreen.main.bounds.height * 0.6
        case .small:
            return UIScreen.main.bounds.height * 0.4
        case .custom(let cGFloat):
            return cGFloat
        }
    }
}

public class PartialSheetHostingController<C: View>: UIHostingController<PaddingTopView<C>>, UIViewControllerTransitioningDelegate {
    private let height: CGFloat
    
    public init(
        size: SheetSize = .medium,
        paddingTop: CGFloat,
        rootView: C
    ) {
        self.height = size.value
        
        super.init(rootView: PaddingTopView(content: rootView, paddingTop: paddingTop))
        super.transitioningDelegate = self
        super.modalPresentationStyle = .custom
    }
    
    @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(height: height, presentedVc: presented, presenting: presenting)
    }
}

class CustomPresentationController: UIPresentationController {
    private let height: CGFloat
    private var panGesture: UIPanGestureRecognizer!
    private var tapOutsideGesture: UITapGestureRecognizer!
    private let thresholdV: CGFloat = 1300
    private var isHiding = false
    
    private lazy var effect: UIView = {
        let effect = UIView()
        effect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effect.alpha = 0
        effect.isUserInteractionEnabled = true
        effect.backgroundColor = UIColor.sfOnBackground.withAlphaComponent(0.5)
        return effect
    }()
    
    private lazy var grabber: UIView = {
        let grabberInteractionZone = UIView(frame: .zero)
        grabberInteractionZone.translatesAutoresizingMaskIntoConstraints = false
        grabberInteractionZone.backgroundColor = .clear
        grabberInteractionZone.isUserInteractionEnabled = true
        
        let grabber = UIView(frame: .zero)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        grabber.backgroundColor = .sfPrimary60
        grabber.layer.cornerRadius = 2
        
        grabberInteractionZone.addSubview(grabber)
        
        NSLayoutConstraint.activate([
            grabberInteractionZone.widthAnchor.constraint(equalToConstant: 100),
            grabberInteractionZone.heightAnchor.constraint(equalToConstant: .L),
            grabber.centerXAnchor.constraint(equalTo: grabberInteractionZone.centerXAnchor),
            grabber.centerYAnchor.constraint(equalTo: grabberInteractionZone.centerYAnchor),
            grabber.widthAnchor.constraint(equalToConstant: .XL),
            grabber.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        return grabberInteractionZone
    }()
    
    init(height: CGFloat, presentedVc: UIViewController, presenting: UIViewController?) {
        self.height = height
        super.init(presentedViewController: presentedVc, presenting: presenting)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        self.tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideAction))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else {
            return super.frameOfPresentedViewInContainerView
        }
        return CGRect(x: 0, y: (container.bounds.height - height), width: container.bounds.width, height: height)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        effect.frame = containerView?.bounds ?? .zero
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        guard let view = presentedView else { return }
        
        containerView?.insertSubview(effect, belowSubview: view)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = Spacing.m.rawValue
        view.addSubview(grabber)
        view.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: view.topAnchor),
            grabber.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        grabber.addGestureRecognizer(panGesture)
        effect.addGestureRecognizer(tapOutsideGesture)
    }
    
    override func presentationTransitionWillBegin() {
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { _ in
                self.effect.alpha = 1
            })
    }
    
    override func dismissalTransitionWillBegin() {
        isHiding = true
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { _ in
                self.effect.alpha = 0
            }, completion: { _ in
                self.effect.removeFromSuperview()
            })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let view = presentedView, !isHiding else {
            return
        }

        if let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = max(0, frameOfPresentedViewInContainerView.minY - rect.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let view = presentedView, !isHiding else {
            return
        }
       
        view.frame.origin.y = frameOfPresentedViewInContainerView.minY
    }
    
    @objc func tapOutsideAction(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        guard let view = presentedView else {
            return
        }
        
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        view.frame.origin = CGPoint(x: 0, y: frameOfPresentedViewInContainerView.minY + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= thresholdV {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.15) { [y = frameOfPresentedViewInContainerView.minY] in
                    view.frame.origin = CGPoint(x: 0, y: y)
                }
            }
        }
    }
}
