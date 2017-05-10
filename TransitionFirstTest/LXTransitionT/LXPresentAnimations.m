//
//  LXPresentAnimations.m
//  LXTransition
//
//  Created by MacBook pro on 16/4/25.
//  Copyright © 2016年 FZ. All rights reserved.
//

#import "LXPresentAnimations.h"

@implementation LXPresentAnimations

-(instancetype)initWithPresentType:(LXPresentType)presentType;{
    
    self = [super init];
    if (self) {
        _currentPresentType=presentType;
        
    }
    return self;
}

+(instancetype)presentType:(LXPresentType)presentType;{
    
    return [[self alloc]initWithPresentType:presentType];
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;{
    
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;{
    
    _transitionContext=transitionContext;
    
    _fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    _fromView=_fromVC.view;
    
    _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _toView=_toVC.view;
    
    // Add toVC's view to containerView
    _containerView = [transitionContext containerView];

    _duration=[self transitionDuration:transitionContext];
    
    switch (_currentPresentType) {
        case LXPresentTypeNone:
            
            [self nomalFromBottom];
            break;
            
        case LXPresentTypeCircleSpread:
            
            [self circleSpread];
            break;
            
        case LXPresentTypePageJust:
            
            [self pageJust];
            break;
        case LXPresentTypeWindowHorizontal:
            
            [self windowHorizontalOpen];
            break;
        case LXPresentTypeWindowVertical:
            
            [self windowVerticalOpen];
            break;
        case LXPresentTypePushCard:
            
            [self pushCard];
            break;
        case LXPresentTypePushFold:
            
            [self pushFold];
            break;
        case LXPresentTypePushTurn:
            
            [self pushTurn];
            break;
        case LXPresentTypePushHurl:
            
            [self pushHurl];
            break;
        case LXPresentTypePushCube:
            
            [self pushCube];
            break;
        case LXPresentTypePushFlip:
            
            [self pushFlip];
            break;
            
        case LXPresentTypeRightPushCard:
            
            [self pushRightCard];
            break;
            
        default:
            break;
    }
      
}

-(void)nomalFromBottom{
    
    //截图视图
    UIView *tempView=[_fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    tempView.frame=_containerView.frame;
    
    [_containerView addSubview:tempView];
    
    _fromVC.view.hidden = YES;
 
    _toVC.view.frame = CGRectMake(0, _containerView.frame.size.height, _toVC.view.frame.size.width, _toVC.view.frame.size.height);
    
    [_containerView addSubview:_toVC.view];
    
    [UIView animateWithDuration:_duration delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:0 animations:^{
        
        _toVC.view.transform = CGAffineTransformMakeTranslation(0, -(_toVC.view.frame.size.height));
        
        [self tempViewHandle:tempView];
        
    } completion:^(BOOL finished) {

        [_transitionContext completeTransition:YES];

    }];
    
}
-(void)tempViewHandle:(UIView *)tempView{
    
    if (!_scale) {
        _scale=.8;
    }
    tempView.transform=CGAffineTransformConcat(CGAffineTransformMakeScale(_scale, _scale), CGAffineTransformMakeTranslation(0,-(_containerView.frame.size.height*(1-_scale)/2-20)));
    
}

-(void)circleSpread{
    
    [_containerView addSubview:_toVC.view];
    
    if (!_begainCircle.size.height) {
        
        CGRect scn=[UIScreen mainScreen].bounds;
        
       _begainCircle=CGRectMake(scn.size.width/2-10, scn.size.height/2-10, 20, 20);
        
    }
    
    //画两个圆路径
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:_begainCircle];
    CGFloat x = MAX(_begainCircle.origin.x, _containerView.frame.size.width - _begainCircle.origin.x);
    CGFloat y = MAX(_begainCircle.origin.y, _containerView.frame.size.height - _begainCircle.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:_containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    _toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = _duration;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
  
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
    
}

-(void)pageJust{
    
    UIView *tempView = [_fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.tag=2002;
    tempView.frame = _fromVC.view.frame;

    [_containerView addSubview:_toVC.view];
    [_containerView addSubview:tempView];
    [_containerView insertSubview:_toVC.view atIndex:0];
    _fromVC.view.hidden = YES;

    CGPoint point=CGPointMake(0, 0.5);
    tempView.frame = CGRectOffset(tempView.frame, (point.x - tempView.layer.anchorPoint.x) * tempView.frame.size.width, (point.y - tempView.layer.anchorPoint.y) * tempView.frame.size.height);
    tempView.layer.anchorPoint = point;
    
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    _containerView.layer.sublayerTransform = transfrom3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = _fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc]initWithFrame:_fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = _fromVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
                          (id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc]initWithFrame:_fromVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [_toVC.view addSubview:toShadow];
    [UIView animateWithDuration:[self transitionDuration:_transitionContext] animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        if ([_transitionContext transitionWasCancelled]) {
            [tempView removeFromSuperview];
            _fromVC.view.hidden = NO;
        }
    }];
  
}

-(void)windowHorizontalOpen{
    
    [_containerView addSubview:_toVC.view];
    
    if (!_begainPoint.x) {
       
        _begainPoint=CGPointMake(_containerView.frame.size.width/2, 0);
    }
  
    CGMutablePathRef startpath=CGPathCreateMutable();//开始
    
    CGPathAddRect(startpath, nil, CGRectMake(_begainPoint.x-0.5, 0, 1,_containerView.frame.size.height));

    CGMutablePathRef endpath=CGPathCreateMutable();//结束
    
    CGPathAddRect(endpath, nil, CGRectMake(0, 0, _containerView.frame.size.width,_containerView.frame.size.height));

    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endpath;
    //将maskLayer作为toVC.View的遮盖
    _toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上
    maskLayerAnimation.fromValue =(__bridge id _Nullable)(startpath);
    maskLayerAnimation.toValue =(__bridge id _Nullable)(endpath);
    maskLayerAnimation.duration = _duration;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}

-(void)windowVerticalOpen{
    [_containerView addSubview:_toVC.view];
    
    if (!_begainPoint.y) {
        
        _begainPoint=CGPointMake(0, _containerView.frame.size.height/2);
    }
    
    CGMutablePathRef startpath=CGPathCreateMutable();//开始
    
    CGPathAddRect(startpath, nil, CGRectMake(0, _begainPoint.y-0.5, _containerView.frame.size.width,1));
    
    CGMutablePathRef endpath=CGPathCreateMutable();//结束
    
    CGPathAddRect(endpath, nil, CGRectMake(0, 0, _containerView.frame.size.width,_containerView.frame.size.height));
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endpath;
    //将maskLayer作为toVC.View的遮盖
    _toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上
    maskLayerAnimation.fromValue =(__bridge id _Nullable)(startpath);
    maskLayerAnimation.toValue =(__bridge id _Nullable)(endpath);
    maskLayerAnimation.duration = _duration;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:_transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
}

-(void)pushCard{
    
    // positions the to- view off the bottom of the sceen
    CGRect frame = [_transitionContext initialFrameForViewController:_fromVC];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    _toView.frame = offScreenFrame;
    
    [_fromView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _fromView.layer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    [_containerView insertSubview:_toView aboveSubview:_fromView];
    
    CATransform3D t1 = [self firstTransform];
    CATransform3D t2 = [self secondTransformWithView:_fromView];
    
    [UIView animateKeyframesWithDuration:_duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view to the back
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            _fromView.layer.transform = t1;
            _fromView.alpha = 0.6;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
            _fromView.layer.transform = t2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
            _toView.frame = CGRectOffset(_toVC.view.frame, 0.0, -30.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
            _toView.frame = frame;
        }];
        
    } completion:^(BOOL finished) {
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

-(CATransform3D)secondTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    return t2;
}

-(void)pushFold{
    
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
        leftToViewFold.layer.position = CGPointMake(size.width, size.height/2);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromView:_toView afterUpdates:YES location:offset + foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(size.width, size.height/2);
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
            leftFromView.layer.position = CGPointMake(0.0, size.height/2);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView* rightFromView = fromViewFolds[i*2+1];
            rightFromView.layer.position = CGPointMake(0.0, size.height/2);
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

-(void)pushTurn{
  
    [_containerView addSubview:_toView];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [_transitionContext initialFrameForViewController:_fromVC];
    _fromView.frame = initialFrame;
    _toView.frame = initialFrame;
    
    float factor = -1.0;
    
    // flip the to VC halfway round - hiding it
    _toView.layer.transform =CATransform3DMakeRotation(factor * -M_PI_2, 0.0, 1.0, 0.0);
    

    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from view
                                                                    _fromView.layer.transform =CATransform3DMakeRotation(factor * M_PI_2, 0.0, 1.0, 0.0);
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
                                  [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
                              }];
    

    
    
}

-(void)pushHurl{

    [_containerView addSubview:_fromView];
    [_containerView addSubview:_toView];
    
    CALayer *fromLayer;
    CALayer *toLayer;
    
    _fromView.userInteractionEnabled = NO;
    
    fromLayer = _fromView.layer;
    toLayer = _toView.layer;
    
    // Change anchor point and reposition it.
    CGRect oldFrame = fromLayer.frame;
    [fromLayer setAnchorPoint:CGPointMake(0.0f, 0.5f)];
    [fromLayer setFrame:oldFrame];
    
    // Reset to initial transform
    sourceFirstTransform(fromLayer);
    destinationFirstTransform(toLayer);
    
    //Perform animation
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f
                                                          relativeDuration:1.0f
                                                                animations:^{
                                                                    destinationLastTransform(toLayer);
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:(1.0f - 0.8)
                                                          relativeDuration:0.8
                                                                animations:^{
                                                                    sourceLastTransform(fromLayer);
                                                                }];
                                  
                              } completion:^(BOOL finished) {
                                  // Bring the from view back to the front and re-enable its user
                                  // interaction since the presentation has been cancelled
                                  if ([_transitionContext transitionWasCancelled])
                                  {
                                      [_containerView bringSubviewToFront:_fromView];
                                      _fromView.userInteractionEnabled = YES;
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

-(void)pushCube{
    
    int dir = 1;
    
    //Create the differents 3D animations
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;

    viewFromTransform = CATransform3DMakeRotation(dir*M_PI_2, 0.0, 1.0, 0.0);
    viewToTransform = CATransform3DMakeRotation(-dir*M_PI_2, 0.0, 1.0, 0.0);
    [_toView.layer setAnchorPoint:CGPointMake(0, 0.5)];
    [_fromView.layer setAnchorPoint:CGPointMake(1, 0.5)];
     _fromView.layer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    [_containerView setTransform:CGAffineTransformMakeTranslation(dir*(_containerView.frame.size.width)/2.0, 0)];
 
    viewFromTransform.m34 = -1.0 / 200.0;
    viewToTransform.m34 = -1.0 / 200.0;
    
    _toView.layer.transform = viewToTransform;
    
    //Create the shadow
    UIView *fromShadow = [self addOpacityToView:_fromView withColor:[UIColor blackColor]];
    UIView *toShadow = [self addOpacityToView:_toView withColor:[UIColor blackColor]];
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
    
    [_containerView addSubview:_toView];
    
    [UIView animateWithDuration:_duration animations:^{
    
    [_containerView setTransform:CGAffineTransformMakeTranslation(-dir*_containerView.frame.size.width/2.0, 0)];
       
        
        _fromView.layer.transform = viewFromTransform;
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

-(void)pushFlip{
    
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
    UIView* flippedSectionOfToView = toViewSnapshots[0];
    
    NSArray* fromViewSnapshots = [self createSnapshots:_fromView afterScreenUpdates:NO];
    UIView* flippedSectionOfFromView = fromViewSnapshots[1];
    
    // replace the from- and to- views with container views that include gradients
    flippedSectionOfFromView = [self addShadowView:flippedSectionOfFromView reverse:NO];
    UIView* flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1];
    flippedSectionOfFromViewShadow.alpha = 0.0;
    
    flippedSectionOfToView = [self addShadowView:flippedSectionOfToView reverse:YES];
    UIView* flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1];
    flippedSectionOfToViewShadow.alpha = 1.0;
    
    // change the anchor point so that the view rotate around the correct edge
    [self updateAnchorPointAndOffset:CGPointMake(0.0, 0.5) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffset:CGPointMake(1.0, 0.5) view:flippedSectionOfToView];
    
    // rotate the to- view by 90 degrees, hiding it
    flippedSectionOfToView.layer.transform = [self rotate: M_PI_2];
    
    
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from- view to 90 degrees
                                                                    flippedSectionOfFromView.layer.transform = [self rotate:-M_PI_2];
                                                                    flippedSectionOfFromViewShadow.alpha = 1.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the to- view to 0 degrees
                                                                    flippedSectionOfToView.layer.transform = [self rotate:0.001];
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


-(void)pushRightCard{
    
    // positions the to- view off the bottom of the sceen
    CGRect frame = [_transitionContext initialFrameForViewController:_fromVC];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.x = -offScreenFrame.size.width;
    _toView.frame = offScreenFrame;
    
    [_fromView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _fromView.layer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    [_containerView insertSubview:_toView aboveSubview:_fromView];
    
    CATransform3D t1 = [self firstRightTransform];
    CATransform3D t2 = [self secondRightTransformWithView:_fromView];
    
    [UIView animateKeyframesWithDuration:_duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view to the back
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            _fromView.layer.transform = t1;
            _fromView.alpha = 0.6;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
            _fromView.layer.transform = t2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
            _toView.frame = CGRectOffset(_toVC.view.frame, -30.0, 0.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
            _toView.frame = frame;
        }];
        
    } completion:^(BOOL finished) {
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

-(CATransform3D)secondRightTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, view.frame.size.width*0.1, 0, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    return t2;
}

@end
