#import "RRWidAnimations.h"
#import "UIColor+RRIM.h"

@implementation RRWidAnimations

#pragma mark - helper

// 设置动画执行的锚点，坐标系为view的父view坐标系
+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CALayer *layer = [view layer];

    CGPoint oldAnchorPoint = layer.anchorPoint;
    CGPoint newAnchor = CGPointMake((anchorPoint.x - view.frame.origin.x) / view.frame.size.width, (anchorPoint.y - view.frame.origin.y) / view.frame.size.height);

    [layer setAnchorPoint:newAnchor];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
}

+ (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer {
    //set the from value (using presentation layer if available)
    animation.fromValue = [(layer.presentationLayer ?: layer) valueForKeyPath:animation.keyPath];

    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];

    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
}

#pragma mark - animations

+ (CAAnimation *)popUpAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint {
    [self setAnchorPoint:anchorPoint forView:view];

    NSValue *scale1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    NSValue *scale2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
    NSValue *scale3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.12, 1)];
    NSValue *scale4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.06, 1.1, 1)];
    NSValue *scale5 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.48f;
    animation.values = @[scale1, scale2, scale3, scale4, scale5];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.65), @(0.8), @(1.0)];

    return animation;
}

+ (CAAnimation *)popDownAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint {
    return [self popDownAnimationWithView:view anchorPoint:anchorPoint expand:NO];
}

+ (CAAnimation *)popDownAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint expand:(BOOL)expand {
    [self setAnchorPoint:anchorPoint forView:view];

    const float duration = 0.24f;

    NSValue *scale1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
    NSValue *scale2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.01, 1.01, 1)];
    NSValue *scale3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.1, 1)];
    NSValue *scale4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.1, 1)];
    NSValue *scale5 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)];
    if (expand) {
        scale5 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
    }

    CAKeyframeAnimation *shrink = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shrink.duration = duration;
    shrink.values = @[scale1, scale2, scale3, scale4, scale5];
    shrink.keyTimes = @[@(0.0), @(0.15), @(0.45), @(0.55), @(1.0)];


    NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)];
    NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)];
    NSValue *point3 = [NSValue valueWithCGPoint:CGPointMake(anchorPoint.x, anchorPoint.y)];

    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    translation.duration = duration;
    translation.values = @[point1, point2, point3];
    translation.keyTimes = @[@(0.0), @(0.55), @(1.0)];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[shrink, translation];
    group.duration = duration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.fillMode = kCAFillModeForwards;

    return group;
}

+ (CAAnimation *)twinkAnimation {
    const float duration = 0.5;

    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.duration = duration;
    scaleAnimation.values = @[@1.0, @1.3, @1.0];
    scaleAnimation.keyTimes = @[@0, @0.5, @1.0];

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.values = @[@1.0, @0.6, @1.0];
    opacityAnimation.keyTimes = @[@0, @0.5, @1.0];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.6;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];

    return animationGroup;
}

+ (CAKeyframeAnimation *)rotationActivityAnimation:(CFTimeInterval)time {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        [arr addObject:@(M_PI / 4 * i)];
    }
    animation.values = arr;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;

    return animation;
}

+ (CAKeyframeAnimation *)shakeAnimation:(CFTimeInterval)time {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[@0, @-2, @2, @-2, @2, @-2, @2, @0, @0];
    animation.keyTimes = @[@0, @(0.05), @(0.25), @(0.35), @(0.45), @(0.55), @(0.65), @(0.7), @(1)];
    animation.duration = time;
    animation.autoreverses = YES;
    animation.repeatCount = FLT_MAX;
    animation.additive = YES;

    return animation;
}

+ (CABasicAnimation *)alternatingColorsAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = .7;
    animation.repeatCount = FLT_MAX;
    animation.autoreverses = YES;
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.fromValue = (id) [UIColor rr_colorWithHexValue:0xfffcde].CGColor;
    animation.toValue = (id) [UIColor rr_colorWithHexValue:0xfff9c1].CGColor;
    animation.removedOnCompletion = NO;

    return animation;
}

//永久旋转的动画
+ (CABasicAnimation *)rotationForeverAnimation:(CFTimeInterval)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转

    animation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    animation.repeatCount = FLT_MAX;
    animation.duration = time;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;

    return animation;
}

//永久闪烁的动画
+ (CABasicAnimation *)opacityForeverAnimation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;

    return animation;
}

// 路径动画
+ (CAKeyframeAnimation *)keyframeAniamtionWithPath:(CGMutablePathRef)path
                                          durTimes:(float)time
                                       repeatTimes:(float)repeatTimes {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    animation.path = path;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;

    return animation;
}

+ (CAKeyframeAnimation *)keyframeAniamtionWithValues:(NSArray *)values
                                            durTimes:(float)time
                                         repeatTimes:(float)repeatTimes {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = values;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;

    return animation;
}

// 替换两个views时，淡入淡出效果
+ (CATransition *)fadeTransitionWithDuration:(CGFloat)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration > 0 ? duration : 0.6;
    transition.removedOnCompletion = YES;
    transition.type = kCATransitionFade;

    return transition;
}

@end
