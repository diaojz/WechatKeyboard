//
//  UIColor+RRIM.m
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import "UIColor+RRIM.h"

@implementation UIColor (RRIM)

+ (UIColor *)rr_colorWithHexValue:(NSInteger)color alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)rr_colorWithHexValue:(NSInteger)color
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:1.0];
}

@end
