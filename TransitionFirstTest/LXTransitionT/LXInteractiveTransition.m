//
//  LXInteractiveTransition.m
//  TransitionFirstTest
//
//  Created by MacBook pro on 16/4/29.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "LXInteractiveTransition.h"

@implementation LXInteractiveTransition
-(instancetype)initWithInteractiveExplain:(LXInteractiveType)insteractiveType optionGesture:(LXGestureType)gestureType;{
    
    if ([super init]) {
       
        _currentInteractiveType=insteractiveType;
        
        _currentGestureDirection=gestureType;
       
    }
    
    return self;
    
}

+(instancetype)interactiveExplain:(LXInteractiveType)insteractiveType optionGesture:(LXGestureType)gestureType;{
    
    
    //仅有单个手势，来或者去
    return [[self alloc]initWithInteractiveExplain:insteractiveType optionGesture:gestureType];
}

-(void)addPanGestureWithFromVC:(UIViewController *)from ToVC:(UIViewController *)to{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    _currentToVC=to;
    
    _currentFromVC=from;
    
    [to.view addGestureRecognizer:pan];//仅返回添加拖动手势
    
}

/**
 追加go手势
 */
-(void)addGoPanGestureAfterWith:(LXInteractiveType)insteractiveType optionGoGesture:(LXGestureType)gestureType;{
    
    _goInteractiveType = insteractiveType;
    
    _goGestureDirection = gestureType;
    
    //添加go手势
    
    UIPanGestureRecognizer *panGo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [_currentFromVC.view addGestureRecognizer:panGo];//添加Go手势
    
}

/**
 *  手势过渡的过程
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture{
    
    LXGestureType type_stand = (panGesture.view == _currentFromVC.view) ? _goGestureDirection : _currentGestureDirection;
    
    //手势百分比
    CGFloat persent = 0;
    switch (type_stand) {
        case LXGestureTypeLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case LXGestureTypeRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case LXGestureTypeUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case LXGestureTypeDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
            
        default:
            break;
            
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.isInterractive = YES;
            [self leaveGesture:(panGesture.view == _currentFromVC.view) ? _goInteractiveType : _currentInteractiveType];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            
            self.isInterractive = NO;
            
            break;
        }
        default:
            break;
    }
}

-(void)leaveGesture:(LXInteractiveType)interactiveType{
    
    switch (interactiveType) {
        case LXInteractiveTypeDismiss:
           [_currentToVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case LXInteractiveTypePop:
            [_currentToVC.navigationController popViewControllerAnimated:YES];
            break;
        case LXInteractiveTypePush:
            [_currentFromVC.navigationController pushViewController:_currentToVC animated:YES];
            break;
        case LXInteractiveTypePresent:
            [_currentFromVC presentViewController:_currentToVC animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}



@end
