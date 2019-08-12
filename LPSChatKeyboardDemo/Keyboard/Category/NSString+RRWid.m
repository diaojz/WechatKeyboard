//
// Created by LiSiYuan on 2018/6/26.
// Copyright (c) 2018 lsy0812@qq.com. All rights reserved.
//

#import "NSString+RRWid.h"
#import "NSAttributedString+RRWid.h"

@implementation NSString (RRWid)


#pragma mark - sizeWithFont
- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self sizeWithFont:font size:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size
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

- (CGSize)sizeWithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
              maxWidth:(CGFloat)maxWidth
{
    return [self sizeWithFont:font lineSpace:lineSpace maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
               maxSize:(CGSize)maxSize
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    return [str sizewithFont:font lineSpace:lineSpace maxSize:maxSize];
}

#pragma mark - AttributedString

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
                                  maxWidth:(CGFloat)maxWidth
{
    return [self strWithFont:font lineSpace:lineSpace maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
                                   maxSize:(CGSize)maxSize
{
    return [NSMutableAttributedString strWithFont:font lineSpace:lineSpace string:self maxSize:maxSize];
}

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
{
    return [NSMutableAttributedString strWithFont:font lineSpace:lineSpace string:self];
}
@end