//
//  NSString+RRIM.m
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import "NSString+RRIM.h"

@implementation NSString (RRIM)

- (CGSize)rr_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self rr_sizeWithFont:font size:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (CGSize)rr_sizeWithFont:(UIFont *)font size:(CGSize)size
{
    if (self.length == 0 || !font) {
        return CGSizeZero;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize boundingBox = [self boundingRectWithSize:size
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes context:nil].size;
    return CGSizeMake(ceilf(boundingBox.width), ceilf(boundingBox.height));
}

@end
