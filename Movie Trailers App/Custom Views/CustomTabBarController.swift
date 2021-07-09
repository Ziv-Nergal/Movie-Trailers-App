//
//  CustomTabBarController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
      super.viewDidLoad()
      delegate = self
    }
}

extension CustomTabBarController: UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
        }, completion: { transitionContext.completeTransition($0) })
    }

    /*
     Asks your animator object for the duration (in seconds) of the transition animation.
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}
