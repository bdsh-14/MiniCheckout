//
//  CustomModalPresentationAnimator.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/27/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class CustomModalPresentationAnimator: NSObject {
    var isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension CustomModalPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
   func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from

      guard let controller = transitionContext.viewController(forKey: key)
        else { return }
        
      if isPresenting {
        transitionContext.containerView.addSubview(controller.view)
      }

      let presentedFrame = transitionContext.finalFrame(for: controller)
      var dismissedFrame = presentedFrame
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
      
        
      let initialFrame = isPresenting ? dismissedFrame : presentedFrame
      let finalFrame = isPresenting ? presentedFrame : dismissedFrame
        
      let animationDuration = transitionDuration(using: transitionContext)
      controller.view.frame = initialFrame
      UIView.animate(
        withDuration: animationDuration,
        animations: {
          controller.view.frame = finalFrame
      }, completion: { finished in
        if !self.isPresenting {
          controller.view.removeFromSuperview()
        }
        transitionContext.completeTransition(finished)
      })
    }
    
}
