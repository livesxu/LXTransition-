//
//  ViewController.m
//  TransitionFirstTest
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "PushNextViewController.h"
#import "LXTransitionManager.h"


@interface ViewController ()<LXTransitionManagerDelegate>

@property (nonatomic, strong)  UIViewController *vc1;

@property (nonatomic, strong)  UIViewController *vc2;

@property (nonatomic, strong)  LXTransitionManager *manager;

@property (nonatomic, strong)  NextViewController *next;

@end

@implementation ViewController


-(void)dealloc{
    
    NSLog(@"From被销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor redColor];
}

- (IBAction)pushSo:(id)sender {
    
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypeRightPushCard BackType:LXDismissTypeRightPopCard];
    
    [self.navigationController pushViewController:pushVC animated:YES];
    
}
- (IBAction)pushFold:(id)sender {
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypePushFold BackType:LXDismissTypePopFold];

    [self.navigationController pushViewController:pushVC animated:YES];
}

- (IBAction)pushTurn:(id)sender {
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypePushTurn BackType:LXDismissTypePopTurn];

    [self.navigationController pushViewController:pushVC animated:YES];
}

- (IBAction)pushHurl:(id)sender {
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypePushHurl BackType:LXDismissTypePopHurl];

    [self.navigationController pushViewController:pushVC animated:YES];
}
- (IBAction)pushCube:(id)sender {
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypePushCube BackType:LXDismissTypePopCube];

    [self.navigationController pushViewController:pushVC animated:YES];
}
- (IBAction)pushFlip:(id)sender {
    PushNextViewController *pushVC=[[PushNextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]pushConfigurationWithOneViewController:self ToViewController:pushVC ToType:LXPresentTypePushFlip BackType:LXDismissTypePopFlip];

    [self.navigationController pushViewController:pushVC animated:YES];
}



- (IBAction)presentSo:(id)sender {
    
    NextViewController *next=[[NextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]presentConfigurationWithOneViewController:self ToViewController:next ToType:LXPresentTypePushHurl BackType:LXDismissTypePopHurl];
    
    [self presentViewController:next animated:YES completion:nil];

}

- (IBAction)presentCircle:(id)sender {
    NextViewController *next=[[NextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]presentConfigurationWithOneViewController:self ToViewController:next ToType:LXPresentTypeCircleSpread BackType:LXDismissTypeCircleSpread];
    
    [self presentViewController:next animated:YES completion:nil];
}

- (IBAction)presentpage:(id)sender {
    NextViewController *next=[[NextViewController alloc]init];
    
    [LXTransitionManager startTransitionManager].delegate=self;
    
    [[LXTransitionManager startTransitionManager]presentConfigurationWithOneViewController:self ToViewController:next ToType:LXPresentTypePageJust BackType:LXDismissTypePageJust];
    
    [self presentViewController:next animated:YES completion:nil];
}

-(NSTimeInterval)presentDuration{
    
    return 2;
}

-(NSTimeInterval)dismissDuration{
    
    return 2;
}
-(CGRect)circleBegainAnimationForLXPresentTypeCircleSpread{
    
    
    return CGRectMake(300, 300, 30, 20);
}

-(LXInteractiveTransition *)addPanInteractiveGestureControl{
    
    
    return [LXInteractiveTransition interactiveExplain:LXInteractiveTypeDismiss optionGesture:LXGestureTypeRight];
    
}

//- (void)appendGoInteractiveGestureControl:(LXInteractiveTransition *)interactiveTransition{
//    
//    [interactiveTransition addGoPanGestureAfterWith:LXInteractiveTypePresent optionGoGesture:LXGestureTypeLeft];
//}

@end
