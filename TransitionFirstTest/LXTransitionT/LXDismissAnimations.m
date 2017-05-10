//
//  LXDismissAnimations.m
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "LXDismissAnimations.h"

@implementation LXDismissAnimations

-(instancetype)initWithDismissType:(LXDismissType)dismissType{
    
    self = [super init];
    if (self) {
       
        _currentDismissType=dismissType;
  
    }
    return self;
}

+(instancetype)dismissType:(LXDismissType)dismissType;{
    
    return [[self alloc]initWithDismissType:dismissType];
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;{
    
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;{
    
    _transitionContext=transitionContext;
    
    _fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    _fromView=_fromVC.view;
    
    _toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _toView=_toVC.view;
    
    _containerView = [transitionContext containerView];
    
    _duration=[self transitionDuration:transitionContext];
    
    
    switch (_currentDismissType) {
        case LXDismissTypeNone:
            [self nomalMatchDismiss];
            break;
        case LXDismissTypeCircleSpread:
            [self circleSpreadMatchDismiss];
            break;
        case LXDismissTypePageJust:
            [self pageJustMatchDismiss];
            break;
        case LXDismissTypeWindowHorizontal:
            
            [self windowHorizontalClose];
            break;
        case LXDismissTypeWindowVertical:
            
            [self windowVerticalClose];
            break;
        case LXDismissTypePopCard:
            
            [self popCard];
            break;
        case LXDismissTypePopFold:
            
            [self popFold];
            break;
        case LXDismissTypePopTurn:
            
            [self popTurn];
            break;
        case LXDismissTypePopHurl:
            
            [self popHurl];
            break;
        case LXDismissTypePopCube:
            
            [self popCube];
            break;
        case LXDismissTypePopFlip:
            
            [self popFlip];
            break;
        case LXDismissTypeRightPopCard:
            
            [self popRightCard];
            break;
         
        default:
            break;
    }
    
 
    
}

-(void)nomalMatchDismiss{
    
    [_containerView addSubview:_toVC.view];
    [_containerView sendSubviewToBack:_toVC.view];
    
    NSArray *subviewsArray = _containerView.subviews;
    
    UIView *tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    //动画吧
    [UIView animateWithDuration:_duration animations:^{
        
        _fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([_transitionContext transitionWasCancelled]) {
            //失败了接标记失败
            [_transitionContext completeTransition:NO];
            
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图
            [_transitionContext completeTransition:YES];
            _toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
  
}
-(void)circleSpreadMatchDismiss{

    [_containerView addSubview:_toVC.view];
    [_containerView sendSubviewToBack:_toVC.view];
    //画两个圆路径
    CGFloat radius = sqrtf(_containerView.frame.size.height * _containerView.frame.size.height + _containerView.frame.size.width * _containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:_containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    if (!_begainCircle.size.height) {
        
        CGRect scn=[UIScreen mainScreen].bounds;
        
        _begainCircle=CGRectMake(scn.size.width/2-10, scn.size.height/2-10, 20, 20);
    }
    
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:_begainCircle];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    _fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:_transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

    
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    if ([transitionContext transitionWasCancelled]) {
        [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    }

}
-(void)pageJustMatchDismiss{
    //拿到push时候的
    UIView *tempView = [_containerView viewWithTag:2002];
    
    [_containerView addSubview:_toVC.view];
    
    [UIView animateWithDuration:_duration animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        _fromVC.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([_transitionContext transitionWasCancelled]) {
            [_transitionContext completeTransition:NO];
        }else{
            [_transitionContext completeTransition:YES];
            [tempView removeFromSuperview];
            _toVC.view.hidden = NO;
        }
    }];
  
}
-(void)windowHorizontalClose{
    [_containerView addSubview:_toVC.view];
    [_containerView sendSubviewToBack:_toVC.view];
    
    if (!_begainPoint.x) {
        
      _begainPoint=CGPointMake(_containerView.frame.size.width/2, 0);
    }

    CGMutablePathRef endpath=CGPathCreateMutable();//结束
    
    CGPathAddRect(endpath, nil, CGRectMake(_begainPoint.x-0.5, 0, 1,_containerView.frame.size.height));
    
    CGMutablePathRef startpath=CGPathCreateMutable();//开始
    
    CGPathAddRect(startpath, nil, CGRectMake(0, 0, _containerView.frame.size.width,_containerView.frame.size.height));

    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endpath;
    _fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startpath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(endpath);
    maskLayerAnimation.duration = _duration;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
}
-(void)windowVerticalClose{
    [_containerView addSubview:_toVC.view];
    [_containerView sendSubviewToBack:_toVC.view];
    
    if (!_begainPoint.y) {
        
        _begainPoint=CGPointMake(0, _containerView.frame.size.height/2);
    }
    
    CGMutablePathRef endpath=CGPathCreateMutable();//结束
    
    CGPathAddRect(endpath, nil, CGRectMake(0, _begainPoint.y-0.5,_containerView.frame.size.width,1));
    
    CGMutablePathRef startpath=CGPathCreateMutable();//开始
    
    CGPathAddRect(startpath, nil, CGRectMake(0, 0, _containerView.frame.size.width,_containerView.frame.size.height));
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endpath;
    _fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startpath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(endpath);
    maskLayerAnimation.duration = _duration;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
}

-(void)popCard{
    // positions the to- view behind the from- view
    CGRect frame = [_transitionContext initialFrameForViewController:_fromVC];
    _toView.frame = frame;
    CATransform3D scale = CATransform3DIdentity;
    _toView.layer.transform = CATransform3DScale(scale, 0.6, 0.6, 1);
    _toView.alpha = 0.6;
    
    [_containerView insertSubview:_toView belowSubview:_fromView];
    
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;
    
    CATransform3D t1 = [self firstTransform];
    
    [UIView animateKeyframesWithDuration:_duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view off the bottom of the screen
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
            _fromView.frame = frameOffScreen;
        }];
        
        // animate the to- view into place
        [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
            _toView.layer.transform = t1;
            _toView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
            _toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        if ([_transitionContext transitionWasCancelled]) {
            _toView.layer.transform = CATransform3DIdentity;
            _toView.alpha = 1.0;
        }
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    }];
    
}
-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
    
}

-(void)popFold{
    // move offscreen
    _toView.frame = CGRectOffset(_toView.frame, _toView.frame.size.width, 0);
    [_containerView addSubview:_toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
    _containerView.layer.sublayerTransform = transform;
    
    CGSize size = _toView.frame.size;
    
    NSUInteger folds=2;
    
    float foldWidth = size.width * 0.5 / (float)folds ;
    
    // arrays that hold the snapshot views
    NSMutableArray* fromViewFolds = [NSMutableArray new];
    NSMutableArray* toViewFolds = [NSMutableArray new];
    
    // create the folds for the form- and to- views
    for (int i=0 ;i<folds; i++){
        float offset = (float)i * foldWidth * 2;
        
        // the left and right side of the fold for the from- view, with identity transform and 0.0 alpha
        // on the shadow, with each view at its initial position
        UIView *leftFromViewFold = [self createSnapshotFromView:_fromView afterUpdates:NO location:offset left:YES];
        leftFromViewFold.layer.position = CGPointMake(offset, size.height/2);
        [fromViewFolds addObject:leftFromViewFold];
        [leftFromViewFold.subviews[1] setAlpha:0.0];
        
        UIView *rightFromViewFold = [self createSnapshotFromView:_fromView afterUpdates:NO location:offset + foldWidth left:NO];
        rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
        [fromViewFolds addObject:rightFromViewFold];
        [rightFromViewFold.subviews[1] setAlpha:0.0];
        
        // the left and right side of the fold for the to- view, with a 90-degree transform and 1.0 alpha
        // on the shadow, with each view positioned at the very edge of the screen
        UIView *leftToViewFold = [self createSnapshotFromView:_toView afterUpdates:YES location:offset left:YES];
        leftToViewFold.layer.position = CGPointMake(0.0, size.height/2);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromView:_toView afterUpdates:YES location:offset + foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(0.0, size.height/2);
        rightToViewFold.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:rightToViewFold];
    }
    
    // move the from- view off screen
    _fromView.frame = CGRectOffset(_fromView.frame, _fromView.frame.size.width, 0);
    

    [UIView animateWithDuration:_duration animations:^{
        // set the final state for each fold
        for (int i=0; i<folds; i++){
            
            float offset = (float)i * foldWidth * 2;
            
            // the left and right side of the fold for the from- view, with 90 degree transform and 1.0 alpha
            // on the shadow, with each view positioned at the edge of thw screen.
            UIView* leftFromView = fromViewFolds[i*2];
            leftFromView.layer.position = CGPointMake(size.width, size.height/2);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView* rightFromView = fromViewFolds[i*2+1];
            rightFromView.layer.position = CGPointMake(size.width, size.height/2);
            rightFromView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 1.0, 0);
            [rightFromView.subviews[1] setAlpha:1.0];
            
            // the left and right side of the fold for the to- view, with identity transform and 0.0 alpha
            // on the shadow, with each view at its final position
            UIView* leftToView = toViewFolds[i*2];
            leftToView.layer.position = CGPointMake(offset, size.height/2);
            leftToView.layer.transform = CATransform3DIdentity;
            [leftToView.subviews[1] setAlpha:0.0];
            
            UIView* rightToView = toViewFolds[i*2+1];
            rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
            rightToView.layer.transform = CATransform3DIdentity;
            [rightToView.subviews[1] setAlpha:0.0];
            
            
        }
    }  completion:^(BOOL finished) {
        // remove the snapshot views
        for (UIView *view in toViewFolds) {
            [view removeFromSuperview];
        }
        for (UIView *view in fromViewFolds) {
            [view removeFromSuperview];
        }
        
        BOOL transitionFinished = ![_transitionContext transitionWasCancelled];
        if (transitionFinished) {
            // restore the to- and from- to the initial location
            _toView.frame = _containerView.bounds;
            _fromView.frame = _containerView.bounds;
        }
        else {
            // restore the from- to the initial location if cancelled
            _fromView.frame = _containerView.bounds;
        }
        [_transitionContext completeTransition:transitionFinished];
    }];
    
}
// creates a snapshot for the gives view
-(UIView*) createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left {
    
    NSUInteger folds=2;
    
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)folds ;
    
    UIView* snapshotView;
    
    if (!afterUpdates) {
        // create a regular snapshot
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        
    } else {
        // for the to- view for some reason the snapshot takes a while to create. Here we place the snapshot within
        // another view, with the same bckground color, so that it is less noticeable when the snapshot initially renders
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
        
    }
    
    // create a shadow
    UIView* snapshotWithShadowView = [self addShadowToView:snapshotView reverse:left];
    
    // add to the container
    [containerView addSubview:snapshotWithShadowView];
    
    // set the anchor to the left or right edge of the view
    snapshotWithShadowView.layer.anchorPoint = CGPointMake( left ? 0.0 : 1.0, 0.5);
    
    return snapshotWithShadowView;
}
- (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse {
    
    // create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

-(void)popTurn{
    
    [_containerView addSubview:_toView];
    //隐藏fromView,用屏幕快照做动画效果
    UIView *tempView=[_fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    tempView.frame=_containerView.frame;
    
    [_containerView addSubview:tempView];
    
    _fromVC.view.hidden = YES;
    
    // Give both VCs the same start frame
    CGRect initialFrame = [_transitionContext initialFrameForViewController:_fromVC];
    _toView.frame = initialFrame;
    
    // flip the to VC halfway round - hiding it
    _toView.layer.transform =CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);

    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from view
                                                                    tempView.layer.transform =CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
                                                                }];

                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the to view
                                                                    _toView.layer.transform =CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
                                                                }];
                              } completion:^(BOOL finished) {
                                  _fromView.layer.transform = CATransform3DIdentity;
                                  _toView.layer.transform = CATransform3DIdentity;
                                  _containerView.layer.transform = CATransform3DIdentity;

                                  if ([_transitionContext transitionWasCancelled]) {
                                      [_transitionContext completeTransition:NO];
                                      _fromVC.view.hidden = NO;
                                      [tempView removeFromSuperview];
                                  }else{
                                      [_transitionContext completeTransition:YES];
                                      [tempView removeFromSuperview];
                                  }
                                  
                              }];
    
}

-(void)popHurl{
    [_containerView addSubview:_fromView];
    [_containerView addSubview:_toView];
    
    CALayer *fromLayer;
    CALayer *toLayer;
    
    _toView.userInteractionEnabled = YES;
    
    fromLayer = _toView.layer;
    toLayer = _fromView.layer;
    
    // Reset to initial transform
    sourceLastTransform(fromLayer);
    destinationLastTransform(toLayer);
    
    
    //Perform animation
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f
                                                          relativeDuration:0.8
                                                                animations:^{
                                                                    sourceFirstTransform(fromLayer);
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f
                                                          relativeDuration:1.0f
                                                                animations:^{
                                                                    destinationFirstTransform(toLayer);
                                                                }];
                              } completion:^(BOOL finished) {
                                  // Bring the from view back to the front and re-disable the user
                                  // interaction of the to view since the dismissal has been cancelled
                                  if ([_transitionContext transitionWasCancelled])
                                  {
                                      [_containerView bringSubviewToFront:_fromView];
                                      _toView.userInteractionEnabled = NO;
                                  }
                                  
                                  _fromView.layer.transform = CATransform3DIdentity;
                                  _toView.layer.transform = CATransform3DIdentity;
                                  _containerView.layer.transform = CATransform3DIdentity;
                                  [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
                              }];

    
    
}
#pragma mark - Required 3d Transform
static void sourceFirstTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500;
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void sourceLastTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0f;
    t = CATransform3DRotate(t, radianFromDegree(80), 0.0f, 1.0f, 0.0f);
    t = CATransform3DTranslate(t, 0.0f, 0.0f, -30.0f);
    t = CATransform3DTranslate(t, 170.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationFirstTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0f / -500.0f;
    // Rotate 5 degrees within the axis of z axis
    t = CATransform3DRotate(t, radianFromDegree(5.0f), 0.0f, 0.0f, 1.0f);
    // Reposition toward to the left where it initialized
    t = CATransform3DTranslate(t, 320.0f, -40.0f, 150.0f);
    // Rotate it -45 degrees within the y axis
    t = CATransform3DRotate(t, radianFromDegree(-45), 0.0f, 1.0f, 0.0f);
    // Rotate it 10 degrees within thee x axis
    t = CATransform3DRotate(t, radianFromDegree(10), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationLastTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    // Rotate to 0 degrees within z axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 0.0f, 1.0f);
    // Bring back to the final position
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    // Rotate 0 degrees within y axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 1.0f, 0.0f);
    // Rotate 0 degrees within  x axis
    t = CATransform3DRotate(t, radianFromDegree(0), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

#pragma mark - Convert Degrees to Radian
static double radianFromDegree(float degrees) {
    return (degrees / 180) * M_PI;
}

-(void)popCube{
    
    int dir = -1;
    
    //Create the differents 3D animations
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;
    
    viewFromTransform = CATransform3DMakeRotation(dir*M_PI_2, 0.0, 1.0, 0.0);
    viewToTransform = CATransform3DMakeRotation(-dir*M_PI_2, 0.0, 1.0, 0.0);
    [_toView.layer setAnchorPoint:CGPointMake(1, 0.5)];
    [_fromView.layer setAnchorPoint:CGPointMake(0, 0.5)];
    
    [_containerView setTransform:CGAffineTransformMakeTranslation(dir*(_containerView.frame.size.width)/2.0, 0)];
    
    
    viewFromTransform.m34 = -1.0 / 200.0;
    viewToTransform.m34 = -1.0 / 200.0;
    
    _toView.layer.transform = viewToTransform;
    
    //Create the shadow
    UIView *fromShadow = [self addOpacityToView:_fromView withColor:[UIColor blackColor]];
    UIView *toShadow = [self addOpacityToView:_toView withColor:[UIColor blackColor]];
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
    
    //Add the to- view
    [_containerView addSubview:_toView];
    
    [UIView animateWithDuration:_duration animations:^{
        
        [_containerView setTransform:CGAffineTransformMakeTranslation(-dir*_containerView.frame.size.width/2.0, 0)];
        
        _fromView.layer.transform = CATransform3DIdentity;
        _toView.layer.transform = CATransform3DIdentity;
        
        [fromShadow setAlpha:1.0];
        [toShadow setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
        //Set the final position of every elements transformed
        [_containerView setTransform:CGAffineTransformIdentity];
        [_fromView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [_toView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        
        [fromShadow removeFromSuperview];
        [toShadow removeFromSuperview];
        
        if ([_transitionContext transitionWasCancelled]) {
            [_toView removeFromSuperview];
        } else {
            [_fromView removeFromSuperview];
        }
        
        // inform the context of completion
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        
    }];
}

- (UIView *)addOpacityToView:(UIView *) view withColor:(UIColor *)theColor
{
    UIView *shadowView = [[UIView alloc] initWithFrame:view.bounds];
    [shadowView setBackgroundColor:[theColor colorWithAlphaComponent:0.8]];
    [view addSubview:shadowView];
    return shadowView;
}

-(void)popFlip{
    
    [_containerView addSubview:_toView];
    [_containerView sendSubviewToBack:_toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [_containerView.layer setSublayerTransform:transform];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [_transitionContext initialFrameForViewController:_fromVC];
    _fromView.frame =  initialFrame;
    _toView.frame = initialFrame;
    
    // create two-part snapshots of both the from- and to- views
    NSArray* toViewSnapshots = [self createSnapshots:_toView afterScreenUpdates:YES];
    UIView* flippedSectionOfToView = toViewSnapshots[1];
    
    NSArray* fromViewSnapshots = [self createSnapshots:_fromView afterScreenUpdates:NO];
    UIView* flippedSectionOfFromView = fromViewSnapshots[0];
    
    // replace the from- and to- views with container views that include gradients
    flippedSectionOfFromView = [self addShadowView:flippedSectionOfFromView reverse:YES];
    UIView* flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1];
    flippedSectionOfFromViewShadow.alpha = 0.0;
    
    flippedSectionOfToView = [self addShadowView:flippedSectionOfToView reverse:NO];
    UIView* flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1];
    flippedSectionOfToViewShadow.alpha = 1.0;
    
    // change the anchor point so that the view rotate around the correct edge
    [self updateAnchorPointAndOffset:CGPointMake(1.0, 0.5) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffset:CGPointMake(0.0, 0.5) view:flippedSectionOfToView];
    
    // rotate the to- view by 90 degrees, hiding it
    flippedSectionOfToView.layer.transform = [self rotate:NO ? M_PI_2 : -M_PI_2];
    
    
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from- view to 90 degrees
                                                                    flippedSectionOfFromView.layer.transform = [self rotate: M_PI_2];
                                                                    flippedSectionOfFromViewShadow.alpha = 1.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the to- view to 0 degrees
                                                                    flippedSectionOfToView.layer.transform = [self rotate: -0.001];
                                                                    flippedSectionOfToViewShadow.alpha = 0.0;
                                                                }];
                              } completion:^(BOOL finished) {
                                  
                                  // remove all the temporary views
                                  if ([_transitionContext transitionWasCancelled]) {
                                      [self removeOtherViews:_fromView];
                                  } else {
                                      [self removeOtherViews:_toView];
                                  }
                                  
                                  // inform the context of completion
                                  [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
                              }];
    
}

// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView* containerView = viewToKeep.superview;
    for (UIView* view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

// adds a gradient to an image by creating a containing UIView with both the given view
// and the gradient as subviews
-(UIView *)addShadowView:(UIView*)view reverse:(BOOL)reverse {
    
    UIView* containerView = view.superview;
    
    // create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // replace the view that we are adding a shadow to
    [containerView insertSubview:viewWithShadow aboveSubview:view];
    [view removeFromSuperview];
    
    // create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

// creates a pair of snapshots from the given view
- (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    
    // snapshot the left-hand side of the view
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the view
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    // send the view that was snapshotted to the back
    [containerView sendSubviewToBack:view];
    
    return @[leftHandView, rightHandView];
}

// updates the anchor point for the given view, offseting the frame to compensate for the resulting movement
- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.x - 0.5;
    view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0);
}


- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}


-(void)popRightCard{
    // positions the to- view behind the from- view
    CGRect frame = [_transitionContext initialFrameForViewController:_fromVC];
    _toView.frame = frame;
    CATransform3D scale = CATransform3DIdentity;
    _toView.layer.transform = CATransform3DScale(scale, 0.6, 0.6, 1);
    _toView.alpha = 0.6;
    
    [_containerView insertSubview:_toView belowSubview:_fromView];
    
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.x = -frame.size.width;
    
    CATransform3D t1 = [self firstRightTransform];
    
    [UIView animateKeyframesWithDuration:_duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view off the bottom of the screen
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
            _fromView.frame = frameOffScreen;
        }];
        
        // animate the to- view into place
        [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
            _toView.layer.transform = t1;
            _toView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
            _toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        if ([_transitionContext transitionWasCancelled]) {
            _toView.layer.transform = CATransform3DIdentity;
            _toView.alpha = 1.0;
        }
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    }];
    
}
-(CATransform3D)firstRightTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 20.0f * M_PI/180.0f, 0, 1, 0);
    return t1;
    
}

@end
