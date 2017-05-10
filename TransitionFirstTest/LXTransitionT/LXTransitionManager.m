//
//  LXTransitionManager.m
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "LXTransitionManager.h"

@implementation LXTransitionManager
+(LXTransitionManager *)startTransitionManager;{
    
    static LXTransitionManager *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance=[[LXTransitionManager alloc]init];
        
    });
   
    return instance;
    
}


//present
-(void)presentConfigurationWithOneViewController:(UIViewController *)fromVC ToViewController:(UIViewController *)toVC ToType:(LXPresentType)toType BackType:(LXDismissType)backType;{
    
    _fromViewController=fromVC;
    
    _toViewController=toVC;
    
    //动画类型，持续时间
    _presentAnimation=[LXPresentAnimations presentType:toType];
    
    _presentAnimation.duration=[self.delegate presentDuration];
  
    _dismissAnimation=[LXDismissAnimations dismissType:backType];
    
    _dismissAnimation.duration=[self.delegate dismissDuration];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleOfTempAnimationForLXPresentTypeNone)]) {
        
        _presentAnimation.scale=[self.delegate scaleOfTempAnimationForLXPresentTypeNone];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleBegainAnimationForLXPresentTypeCircleSpread)]) {
        
        _presentAnimation.begainCircle=[self.delegate circleBegainAnimationForLXPresentTypeCircleSpread];
        _dismissAnimation.begainCircle=[self.delegate circleBegainAnimationForLXPresentTypeCircleSpread];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pointBegainAnimationForLXPresentTypeWindowOpen)]) {
        _presentAnimation.begainPoint=[self.delegate pointBegainAnimationForLXPresentTypeWindowOpen];
        _dismissAnimation.begainPoint=[self.delegate pointBegainAnimationForLXPresentTypeWindowOpen];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addPanInteractiveGestureControl)]) {
        
        self.interactiveTransition=[self.delegate addPanInteractiveGestureControl];
        [_interactiveTransition addPanGestureWithFromVC:_fromViewController ToVC:_toViewController];
        
        //追加go手势
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendGoInteractiveGestureControl:)]) {
            
            [self.delegate appendGoInteractiveGestureControl:self.interactiveTransition];
        }
    }
    
    _toViewController.transitioningDelegate=self;
    
}

//dismiss
-(void)dismissOneViewController;{
        
    [_toViewController dismissViewControllerAnimated:YES completion:^{
        
        _toViewController=nil;
        
    }];
    
}

//push
-(void)pushConfigurationWithOneViewController:(UIViewController *)fromVC ToViewController:(UIViewController *)toVC ToType:(LXPresentType)toType BackType:(LXDismissType)backType;{
    
    _fromViewController=fromVC;
    
    _toViewController=toVC;
    
    //动画类型
    _presentAnimation=[LXPresentAnimations presentType:toType];
    
    _dismissAnimation=[LXDismissAnimations dismissType:backType];
    
     _presentAnimation.duration=[self.delegate presentDuration];
    
     _dismissAnimation.duration=[self.delegate dismissDuration];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleBegainAnimationForLXPresentTypeCircleSpread)]) {
        
        _presentAnimation.begainCircle=[self.delegate circleBegainAnimationForLXPresentTypeCircleSpread];
        _dismissAnimation.begainCircle=[self.delegate circleBegainAnimationForLXPresentTypeCircleSpread];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pointBegainAnimationForLXPresentTypeWindowOpen)]) {
        _presentAnimation.begainPoint=[self.delegate pointBegainAnimationForLXPresentTypeWindowOpen];
        _dismissAnimation.begainPoint=[self.delegate pointBegainAnimationForLXPresentTypeWindowOpen];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addPanInteractiveGestureControl)]) {
        
        self.interactiveTransition=[self.delegate addPanInteractiveGestureControl];
        [_interactiveTransition addPanGestureWithFromVC:_fromViewController ToVC:_toViewController];
        
        //追加go手势
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendGoInteractiveGestureControl:)]) {
            
            [self.delegate appendGoInteractiveGestureControl:self.interactiveTransition];
        }
    }
    
    _fromViewController.navigationController.delegate=self;

}


#pragma mark-UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;{
  
    return _presentAnimation;
    
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;{
    
    return _dismissAnimation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;{
    
    return _interactiveTransition.isInterractive ? _interactiveTransition : nil;
}

#pragma mark-UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);{
    
    return (operation==UINavigationControllerOperationPush ? _presentAnimation :_dismissAnimation) ;
    
}
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);{
    
    return _interactiveTransition.isInterractive ? _interactiveTransition : nil;
}

@end
