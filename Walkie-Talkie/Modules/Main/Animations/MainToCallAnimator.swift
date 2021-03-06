//
//  MainToCallAnimator.swift
//  Walkie-Talkie
//
//  Created by Zaporozhchenko Oleksandr on 5/9/20.
//  Copyright © 2020 maxatma. All rights reserved.
//

import UIKit


final class MainToCallAnimator: BaseAnimator<MainVC, CallVC> {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
        containerView.add(toVC.view)
        containerView.sendSubviewToBack(toVC.view)
        toVC.view.alpha = 0
        toVC.pipVC.view.alpha = 0
        
        guard
            let videoView = fromVC.myVideo?.videoView,
            let videoViewSnapshot = videoView.snapshotView(afterScreenUpdates: false)
            else {
                transitionContext.completeTransition(true)
                return
        }
        
        
        videoViewSnapshot.frame = videoView.frameOfViewInWindowsCoordinateSystem()
        
        containerView
            .add(
                videoViewSnapshot
        )
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView
            .animateKeyframes(withDuration: duration,
                              delay: 0,
                              options: .calculationModeLinear,
                              animations: {
                                
                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                   relativeDuration: 0.1,
                                                   animations: { [unowned self] in
                                                    self.fromVC.view.alpha = 0
                                })
                                
                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                   relativeDuration: 1,
                                                   animations: { [unowned self] in
                                                    videoViewSnapshot.frame = self.toVC.pipVC.view.frameOfViewInWindowsCoordinateSystem()
                                })
                                
                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                   relativeDuration: 1,
                                                   animations: { [unowned self] in
                                                    self.toVC.view.alpha = 1
                                })
            },
                              completion: { [unowned self] _ in
                                self.toVC.pipVC.view.alpha = 1

                                self.containerView
                                    .remove(
                                        videoViewSnapshot
                                )
                                
                                
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
