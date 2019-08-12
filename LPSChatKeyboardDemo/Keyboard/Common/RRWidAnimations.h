#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RRWidAnimations : NSObject

+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

+ (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer;

// 弹出动画
+ (CAAnimation *)popUpAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint;

// 弹回动画
+ (CAAnimation *)popDownAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint;

+ (CAAnimation *)popDownAnimationWithView:(UIView *)view anchorPoint:(CGPoint)anchorPoint expand:(BOOL)expand;

// 替换两个views时，淡入淡出效果
+ (CATransition *)fadeTransitionWithDuration:(CGFloat)duration;

//永久旋转的动画
+ (CABasicAnimation *)rotationForeverAnimation:(CFTimeInterval)time;

+ (CAKeyframeAnimation *)shakeAnimation:(CFTimeInterval)time;

+ (CAKeyframeAnimation *)rotationActivityAnimation:(CFTimeInterval)time;

//颜色交替变换
+ (CABasicAnimation *)alternatingColorsAnimation;

@end
