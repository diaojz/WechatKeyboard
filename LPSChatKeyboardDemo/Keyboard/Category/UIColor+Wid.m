//
//  UIColor+Wid.m
//  LPSChatKeyboardDemo
//
//  Created by Daniel_Lee on 2019/8/12.
//  Copyright © 2019 renrui. All rights reserved.
//

#import "UIColor+Wid.h"

@implementation UIColor (Wid)

+ (UIColor *)colorWithHexValue:(NSInteger)color alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSInteger)color
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:1.0];
}

@end
