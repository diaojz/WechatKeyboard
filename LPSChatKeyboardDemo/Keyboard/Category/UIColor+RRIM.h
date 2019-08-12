//
//  UIColor+RRIM.h
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RRIM)

+ (UIColor *)rr_colorWithHexValue:(NSInteger)color alpha:(CGFloat)alpha;

+ (UIColor *)rr_colorWithHexValue:(NSInteger)color;

@end
