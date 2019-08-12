//
//  NSString+RRIM.h
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RRIM)

- (CGSize)rr_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (CGSize)rr_sizeWithFont:(UIFont *)font size:(CGSize)size;

@end
