//
//  CustomModalPresentationManager.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/27/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

/// Possible custom modal presentation style
enum CustomModalPresentationStyle: CGFloat {
    case fullScreen
    case partiallyRevealed
    case halfScreen
    
    func offSetFromTop() -> CGFloat {
        switch self {
        case .halfScreen:
            return UIScreen.main.bounds.height * 0.4
        case .partiallyRevealed:
            return UIScreen.main.bounds.height * 0.1
        default:
            return 0
        }
    }
    
    func heightForPresentedView(parentSize: CGSize) -> CGFloat {
        switch self {
        case .halfScreen, .partiallyRevealed:
            return parentSize.height - self.offSetFromTop()
        default:
            return parentSize.height
        }
    }
}

class CustomModalPresentationManager: NSObject {
    var currentPresentationStyle: CustomModalPresentationStyle = .partiallyRevealed
    
    /// Boolean value which indicates whether modal presentation is intiated from container view or normal view controller
    var isPresentingFromContainerView: Bool = false
}


// MARK: - UIViewControllerTransitioningDelegate
extension CustomModalPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(
      forPresented presented: UIViewController,
      presenting: UIViewController?,
      source: UIViewController
    ) -> UIPresentationController? {
      let presentationController = CustomModalPresentationalController(
        presentedViewController: presented,
        presenting: isPresentingFromContainerView ? source: presenting,
        currentPresentationStyle: currentPresentationStyle
        )
      return presentationController
    }
    
    func animationController(
      forPresented presented: UIViewController,
      presenting: UIViewController,
      source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
      return CustomModalPresentationAnimator(isPresenting: true)
    }

    func animationController(
      forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
      return CustomModalPresentationAnimator(isPresenting: false)
    }
}
