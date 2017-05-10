//
//  LXDismissAnimations.h
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LXDismissAnimations : NSObject<UIViewControllerAnimatedTransitioning>
typedef NS_ENUM(NSInteger,LXDismissType){
    
    LXDismissTypeNone,
    LXDismissTypeCircleSpread,
    LXDismissTypePageJust,
    LXDismissTypeWindowHorizontal,
    LXDismissTypeWindowVertical,
    LXDismissTypePopCard,
    LXDismissTypePopFold,//褶皱
    LXDismissTypePopTurn,//翻转
    LXDismissTypePopHurl,//横甩
    LXDismissTypePopCube,//方块翻
    LXDismissTypePopFlip,//半翻页
    
    LXDismissTypeRightPopCard
};

@property(nonatomic,assign)LXDismissType currentDismissType;

@property(nonatomic,weak)id <UIViewControllerContextTransitioning> transitionContext;

@property(nonatomic,strong)UIViewController *fromVC;

@property(nonatomic,strong)UIView *fromView;

@property(nonatomic,strong)UIViewController *toVC;

@property(nonatomic,strong)UIView *toView;

@property(nonatomic,strong)UIView *containerView;

@property(nonatomic,assign)NSTimeInterval duration;

@property(nonatomic,assign)CGRect begainCircle;//CircleSpreadType中缩放起始位置

@property(nonatomic,assign)CGPoint begainPoint;//windowType中终点位置

@property(nonatomic,strong)UIView *currentTempView;

+(instancetype)dismissType:(LXDismissType)dismissType;

@end
