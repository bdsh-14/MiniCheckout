//
//  CustomModalPresentationController.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/27/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

final class CustomModalPresentationalController: UIPresentationController {
    
    /// Minimum drag down velocity which is needed to close modal view
    private var minimumVelocityToHide: CGFloat = 1500
    
    /// Minimum screen ratio to hide modal view while dragging
    private var minimumScreenRatioToHide: CGFloat = 0.5
    
    /// Minimum screen ratio to change currrent modal presentation style
    private var minimumScreenRatioToChangePresentationStyle: CGFloat = 0.25
    
    /// Animation duration of modal view transistions
    private var animationDuration: TimeInterval = 0.2
    
    /// Top dark line padding value
    private var topDarkLinePadding: CGFloat = 20.0
    
    /// Boolean value which track dragg direction
    private var isScreenDraggDownwards: Bool = true
    
    /// Holds initial modal view offset poistion
    private var intialModalViewPosition: CGPoint!

    /// Holds current modal state
    private var currentPresentationStyle: CustomModalPresentationStyle = .partiallyRevealed
    
    /// Dimming view for background'
    private var dimmingView: UIView!
    
    /// Top dark line view
    private lazy  var topDarkLineView: UIView = {
       let topdarkLineView = UIView(frame: CGRect(x: 0, y: 0, width: 78, height: 10))
        topdarkLineView.cornerRadius = 4.0
        topdarkLineView.backgroundColor = .systemGreen
        return topdarkLineView
    }()
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, currentPresentationStyle: CustomModalPresentationStyle = .partiallyRevealed) {
        self.currentPresentationStyle = currentPresentationStyle
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.setUpDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = self.dimmingView else { return }
        
        // Adding dimming view to modal view
        containerView?.insertSubview(dimmingView, at: 0)
        
        // Add Top dark line view
        containerView?.insertSubview(topDarkLineView, at: 1)
        
        // Add constraints to dimming view
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        // Animation starts along with view controller presentation
        coordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1.0
        }, completion: nil)
        
        // Add Drag gesture to container view
        guard let containerView = containerView else { return }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            self.dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        // Adding corners
        presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
        topDarkLineView.frame.origin = CGPoint(x: presentedView!.center.x - topDarkLineView.frame.size.width / 2, y: currentPresentationStyle.offSetFromTop() - topDarkLinePadding)
    }
    
    /// Here we can set size of modal view
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: currentPresentationStyle.heightForPresentedView(parentSize: parentSize))
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        
        // Set Offset for modally presented view
        frame.origin.y = currentPresentationStyle.offSetFromTop()
        intialModalViewPosition = frame.origin
        return frame
    }
}


extension CustomModalPresentationalController {
    /// Creates Dimming view
    func setUpDimmingView() {
        self.dimmingView = UIView()
        self.dimmingView.alpha = 0.0
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        // Add Tap gesture
        let tapRecognizer = UITapGestureRecognizer(
          target: self,
          action: #selector(handleTap(recognizer:)))
        self.dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.presentedViewController.view.frame.origin = CGPoint(x: 0, y: y)
        topDarkLineView.frame.origin = CGPoint(x: presentedView!.center.x - topDarkLineView.frame.size.width / 2, y: presentedViewController.view.frame.origin.y - topDarkLinePadding)

    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        guard let containerView = containerView else { return }

        switch panGesture.state {
        case  .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: self.presentedViewController.view)
            var y = translation.y
            isScreenDraggDownwards = y > 0
            
            if isScreenDraggDownwards {
                y = max(0, y)
            } else {
                switch currentPresentationStyle {
                case .fullScreen:
                    y = max(0, y)
                case .halfScreen, .partiallyRevealed:
                    // Can't drag modal view upwards beyond CGPoint.Zero
                    guard intialModalViewPosition.y + y >= CGPoint.zero.y else { return }
                }
            }
            print(y)
            slideViewVerticallyTo(y + intialModalViewPosition.y)
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: self.presentedViewController.view)
            let velocity = panGesture.velocity(in: self.presentedViewController.view)
            let closing = (translation.y > self.presentedViewController.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.slideViewVerticallyTo(containerView.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.presentedViewController.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to new position based on current presentation style
                var newModalViewPosition = self.intialModalViewPosition.y
                let translation = panGesture.translation(in: self.presentedViewController.view)
                
                if !isScreenDraggDownwards {
                    switch currentPresentationStyle {
                    case .fullScreen, .partiallyRevealed:
                        // Can't drag modal view upwards beyond CGPoint.Zero
                        guard intialModalViewPosition.y + translation.y >= CGPoint.zero.y else {
                            break
                        }

                        if abs(translation.y) >= self.presentedViewController.view.frame.size.height * minimumScreenRatioToChangePresentationStyle {
                            newModalViewPosition = CustomModalPresentationStyle.halfScreen.offSetFromTop()
                            currentPresentationStyle = .halfScreen
                            intialModalViewPosition = CGPoint(x: 0, y: newModalViewPosition)
                            UIView.animate(withDuration: animationDuration, animations: {
                                self.slideViewVerticallyTo(newModalViewPosition)
                                self.presentedView?.frame.size.height = CustomModalPresentationStyle.halfScreen.heightForPresentedView(parentSize: self.presentingViewController.view.frame.size)
                            })
                            return
                        }
                        
                    case .halfScreen:
                        if abs(translation.y) > self.presentedViewController.view.frame.size.height * minimumScreenRatioToChangePresentationStyle {
                            newModalViewPosition = CustomModalPresentationStyle.partiallyRevealed.offSetFromTop()
                            currentPresentationStyle = .partiallyRevealed
                            intialModalViewPosition = CGPoint(x: 0, y: newModalViewPosition)
                            UIView.animate(withDuration: animationDuration, animations: {
                                self.slideViewVerticallyTo(newModalViewPosition)
                                self.presentedView?.frame.size.height = CustomModalPresentationStyle.partiallyRevealed.heightForPresentedView(parentSize: self.presentingViewController.view.frame.size)
                            })
                            return
                        }
                    }
                    
                } else {
                    switch currentPresentationStyle {
                    case .fullScreen, .partiallyRevealed:
                        if abs(translation.y) > self.presentedViewController.view.frame.size.height * minimumScreenRatioToChangePresentationStyle {
                            newModalViewPosition = CustomModalPresentationStyle.halfScreen.offSetFromTop()
                            currentPresentationStyle = .halfScreen
                            intialModalViewPosition = CGPoint(x: 0, y: newModalViewPosition)
                            UIView.animate(withDuration: animationDuration, animations: {
                                self.slideViewVerticallyTo(newModalViewPosition)
                                self.presentedView?.frame.size.height = CustomModalPresentationStyle.halfScreen.heightForPresentedView(parentSize: self.presentingViewController.view.frame.size)
                                return
                            })
                        }
                        
                    case .halfScreen:
                        print("Don't have to do anything")
                    }
                }
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(newModalViewPosition)
                })
            }
            
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(self.intialModalViewPosition.y)
            })
            
        }
    }
    
    
    /// Dismiss modal view when tapped on dimming view
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
      presentingViewController.dismiss(animated: true)
    }
}
