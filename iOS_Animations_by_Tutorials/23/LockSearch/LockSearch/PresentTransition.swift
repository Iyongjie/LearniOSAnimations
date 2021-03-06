//
//  ViewController.swift
//  LockSearch
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/18.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class PresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
  
  var auxAnimations: (() -> Void)?
  var auxAnimationsCancel: (() -> Void)?
  
  var context: UIViewControllerContextTransitioning?
  var animator: UIViewPropertyAnimator?
  
  //MARK: - UIViewControllerAnimatedTransitioning
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.75
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    transitionAnimator(using: transitionContext).startAnimation()
  }
  
  func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    // 为转场做准备
    let duration = transitionDuration(using: transitionContext)
    let container = transitionContext.containerView
    let to = transitionContext.view(forKey: .to)!
    
    container.addSubview(to)
    
    //
    to.transform = CGAffineTransform(scaleX: 1.33, y: 1.33).concatenating(CGAffineTransform(translationX: 0.0, y: 200))
    to.alpha = 0
    
    // 添加动画师来运行转换
    let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
    
    animator.addAnimations({
      to.transform = CGAffineTransform(translationX: 0.0, y: 100)
    }, delayFactor: 0.15)
    
    animator.addAnimations({
      to.alpha = 1.0
    }, delayFactor: 0.5)
    
//    animator.addCompletion { (_) in
//      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    }
    animator.addCompletion { (position) in
      switch position {
      case .end:
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      default:
        transitionContext.completeTransition(false)
        self.auxAnimationsCancel?()
      }
    }
    
    if let auxAnimations = auxAnimations {
      animator.addAnimations(auxAnimations)
    }
    
    self.animator = animator
    self.context = transitionContext
    
    animator.addCompletion { [unowned self] _  in
      self.animator = nil
      self.context = nil
    }
    
    animator.isUserInteractionEnabled = true
    
    return animator
  }
  // 可中断动画师
  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    return transitionAnimator(using: transitionContext)
  }
  
  func interruptTransition() {
    guard let context = context else { return }
    context.pauseInteractiveTransition()
    pause()
  }
}
