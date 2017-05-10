//
//  LXTransitionManager.h
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LXPresentAnimations.h"
#import "LXDismissAnimations.h"
#import "LXInteractiveTransition.h"


@protocol LXTransitionManagerDelegate <NSObject>

@required

-(NSTimeInterval)presentDuration;

-(NSTimeInterval)dismissDuration;

@optional

-(CGFloat)scaleOfTempAnimationForLXPresentTypeNone;

-(CGRect)circleBegainAnimationForLXPresentTypeCircleSpread;

-(CGPoint)pointBegainAnimationForLXPresentTypeWindowOpen;

-(LXInteractiveTransition *)addPanInteractiveGestureControl;//返回拖动手势

-(void)appendGoInteractiveGestureControl:(LXInteractiveTransition *)interactiveTransition;

@end

@interface LXTransitionManager : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIViewController *fromViewController;

@property(nonatomic,strong)UIViewController *toViewController;

@property(nonatomic,weak)id <LXTransitionManagerDelegate>delegate;

@property(nonatomic,strong)LXPresentAnimations *presentAnimation;

@property(nonatomic,strong)LXDismissAnimations *dismissAnimation;

@property(nonatomic,strong)LXInteractiveTransition *interactiveTransition;


+(LXTransitionManager *)startTransitionManager;

-(void)presentConfigurationWithOneViewController:(UIViewController *)fromVC ToViewController:(UIViewController *)toVC ToType:(LXPresentType)toType BackType:(LXDismissType)backType;

-(void)pushConfigurationWithOneViewController:(UIViewController *)fromVC ToViewController:(UIViewController *)toVC ToType:(LXPresentType)toType BackType:(LXDismissType)backType;


@end
