//
//  LXInteractiveTransition.h
//  TransitionFirstTest
//
//  Created by MacBook pro on 16/4/29.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXInteractiveTransition : UIPercentDrivenInteractiveTransition

typedef NS_OPTIONS(NSInteger, LXGestureType){
    
    LXGestureTypeLeft = 0,//向左
    LXGestureTypeRight,//向右
    LXGestureTypeUp,//向上
    LXGestureTypeDown,//向下
    LXGestureTypeCenter,//向中
    LXGestureTypeOut//向外
  
};


typedef NS_ENUM(NSInteger,LXInteractiveType){//present和push手势目前并不涉及到
    
    LXInteractiveTypePresent = 1,
    LXInteractiveTypeDismiss,
    LXInteractiveTypePush,
    LXInteractiveTypePop
 
};
@property(nonatomic,assign)BOOL isBothFromTo;//是否来去都有手势控制

@property(nonatomic,assign)BOOL isInterractive;//是否手势中

@property(nonatomic,assign)LXInteractiveType currentInteractiveType;//交互类型

@property(nonatomic,assign)LXGestureType currentGestureDirection;//手势方向

@property(nonatomic,assign)LXInteractiveType goInteractiveType;//go交互类型

@property(nonatomic,assign)LXGestureType goGestureDirection;//go手势方向

@property(nonatomic,strong)UIViewController *currentFromVC;

@property(nonatomic,strong)UIViewController *currentToVC;

+(instancetype)interactiveExplain:(LXInteractiveType)insteractiveType optionGesture:(LXGestureType)gestureType;

-(void)addPanGestureWithFromVC:(UIViewController *)from ToVC:(UIViewController *)to;

/**
 追加go手势
 */
-(void)addGoPanGestureAfterWith:(LXInteractiveType)insteractiveType optionGoGesture:(LXGestureType)gestureType;

@end
