//
//  RRUtilities.m
//  RRIM
//
//  Created by LiSiYuan on 2018/6/25.
//  Copyright © 2018 lsy0812@qq.com. All rights reserved.
//

#import "RRUtilities.h"
#import <AVFoundation/AVFoundation.h>
#define kTopViewContentOriginY  20
#define kTopViewContentHeight   44
#define kTopViewHeight (kTopViewContentOriginY + kTopViewContentHeight)

#define kTextFieldLeftViewSize 15

#define kXTopViewContentOriginY 44

#define kXTopViewHeight (kXTopViewContentOriginY + kTopViewContentHeight)

#define kTabBarHeight 49

#define kXTopSafeHeight 24
#define kXTabBarSafeHeight 34
@implementation RRUtilities
+ (UIViewController *_Nullable)getCurrentVC
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


    UIView *frontView = [window subviews].count>0?[[window subviews] objectAtIndex:0]:nil;
    id nextResponder = [frontView nextResponder];


    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    UIViewController *vc = [self currentVCWithVC:result];
    return vc;
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

+ (CGFloat)topViewHeight {
    if ([RRUtilities iPhoneX]) {
        return kXTopViewHeight;
    }
    return kTopViewHeight;
}
+ (BOOL)iPhoneX {
    return [UIScreen mainScreen].bounds.size.height == 812;
}

+ (NSInteger)numberWithHexString:(NSString *)hexString{
    if (hexString.length == 0){
        return 0;
    }
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];

    int hexNumber;

    sscanf(hexChar, "%x", &hexNumber);

    return (NSInteger)hexNumber;
}
+ (BOOL)checkCameraAuthorizationStatus {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return NO;
    }

    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
                AVAuthorizationStatusRestricted == authStatus) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:setAction];
            [[RRUtilities getCurrentVC] presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
    }

    return YES;
}
@end
