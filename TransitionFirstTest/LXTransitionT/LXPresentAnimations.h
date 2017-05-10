//
//  LXPresentAnimations.h
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NomalPresentBlock)(UIViewController *toVC,UIView *tempView);

@interface LXPresentAnimations : NSObject<UIViewControllerAnimatedTransitioning>

typedef NS_ENUM(NSInteger,LXPresentType){
    
    LXPresentTypeNone,//底部出现
    LXPresentTypeCircleSpread,//圆圈
    LXPresentTypePageJust,//翻页
    LXPresentTypeWindowHorizontal,//水平开窗
    LXPresentTypeWindowVertical,   //竖直开窗
    LXPresentTypePushCard,//卡片
    LXPresentTypePushFold,//褶皱
    LXPresentTypePushTurn,//翻转
    LXPresentTypePushHurl,//横甩
    LXPresentTypePushCube,//方块翻
    LXPresentTypePushFlip,//半翻页
    
    LXPresentTypeRightPushCard//向右抽卡
    
};



@property(nonatomic,assign)LXPresentType currentPresentType;

@property(nonatomic,weak)id <UIViewControllerContextTransitioning> transitionContext;

@property(nonatomic,strong)UIViewController *fromVC;

@property(nonatomic,strong)UIView *fromView;

@property(nonatomic,strong)UIViewController *toVC;

@property(nonatomic,strong)UIView *toView;

@property(nonatomic,strong)UIView *containerView;

@property(nonatomic,assign)NSTimeInterval duration;

@property(nonatomic,assign)CGFloat scale;//NoneType中tempView缩放动画比例

@property(nonatomic,assign)CGRect begainCircle;//CircleSpreadType中缩放起始位置

@property(nonatomic,assign)CGPoint begainPoint;//windowType中起点位置

@property(nonatomic,copy)NomalPresentBlock nomalPresent;



+(instancetype)presentType:(LXPresentType)presentType;
@end
