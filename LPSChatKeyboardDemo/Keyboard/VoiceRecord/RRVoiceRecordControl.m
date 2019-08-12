//
//  RRVoiceRecordControl.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRVoiceRecordControl.h"
#import "RRVoiceRecordView.h"

@interface RRVoiceRecordControl ()

@property (nonatomic, strong) RRVoiceRecordView *voiceRecordView;
@property (nonatomic, strong) RRVoiceRecordTipView *tipView;

@end

@implementation RRVoiceRecordControl

- (void)updatePower:(float)power
{
    [self.voiceRecordView updatePower:power];
}

- (void)showRecordCounting:(float)remainTime
{
    [self.voiceRecordView updateWithRemainTime:remainTime];
}

- (void)showToast:(NSString *)message complete:(void (^)())complete
{
    if (!self.tipView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.tipView];
        [self.tipView showWithMessage:message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
            [self.tipView removeFromSuperview];
        });
    }
}

- (void)updateUIWithRecordState:(RRVoiceRecordState)state
{
    if (state == RRVoiceRecordStateNormal || state == RRVoiceRecordStateStoped) {
        if (self.voiceRecordView.superview) {
            [self.voiceRecordView removeFromSuperview];
        }
        return;
    }
    
    if (!self.voiceRecordView.superview) {
        [[RRVoiceRecordControl alertView] addSubview:self.voiceRecordView];
    }
    
    [self.voiceRecordView updateUIWithRecordState:state];
}

+ (UIView *)alertView
{
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    UIViewController *vc = [self currentVCWithVC:result];
    return vc.view;
}
+ (UIViewController *)currentVCWithVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self currentVCWithVC:((UITabBarController *) vc).selectedViewController];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self currentVCWithVC:((UINavigationController *) vc).visibleViewController];
    }
    
    return vc;
}

- (RRVoiceRecordView *)voiceRecordView
{
    if (!_voiceRecordView) {
        _voiceRecordView = [[RRVoiceRecordView alloc] initWithFrame:CGRectMake(0, 0, 105, 105)];
        _voiceRecordView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _voiceRecordView;
}

- (RRVoiceRecordTipView *)tipView
{
    if (!_tipView) {
        _tipView = [[RRVoiceRecordTipView alloc] initWithFrame:CGRectMake(0, 0, 105, 105)];
        _tipView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _tipView;
}

@end
