//
//  LPSUtilities.m
//  LPSChatKeyboardDemo
//
//  Created by Daniel_Lee on 2019/8/12.
//  Copyright © 2019 renrui. All rights reserved.
//

#import "LPSUtilities.h"

@implementation LPSUtilities

+ (BOOL)iPhoneX {
    
    GBDeviceInfo *info = [GBDeviceInfo deviceInfo];
    return (info.model == GBDeviceModeliPhoneX || info.model == GBDeviceModeliPhoneXR || info.model == GBDeviceModeliPhoneXS || info.model == GBDeviceModeliPhoneXSMax);
}

+ (CGFloat)layoutSafeBottom {
    if ([LPSUtilities iPhoneX]) {
        return kXTabBarSafeHeight;
    }
    return 0;
}

+ (CGFloat)layoutSafeTop {
    if ([LPSUtilities iPhoneX]) {
        return kXTopSafeHeight;
    }
    return 0;
}

@end
