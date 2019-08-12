//
//  LPSUtilities.h
//  LPSChatKeyboardDemo
//
//  Created by Daniel_Lee on 2019/8/12.
//  Copyright © 2019 renrui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXTopSafeHeight 24
#define kXTabBarSafeHeight 34

NS_ASSUME_NONNULL_BEGIN

@interface LPSUtilities : NSObject

+ (CGFloat)layoutSafeBottom;

+ (CGFloat)layoutSafeTop;

@end

NS_ASSUME_NONNULL_END
