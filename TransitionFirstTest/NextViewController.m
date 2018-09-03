//
//  NextViewController.m
//  TransitionFirstTest
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "NextViewController.h"
#import "LXTransitionManager.h"

@interface NextViewController ()

@end

@implementation NextViewController

-(void)dealloc{
    
    NSLog(@"TO被销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor=[UIColor greenColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setTitle:@"Dismiss me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)buttonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




@end
