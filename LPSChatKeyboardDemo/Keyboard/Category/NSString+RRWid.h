//
// Created by LiSiYuan on 2018/6/26.
// Copyright (c) 2018 lsy0812@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RRWid)
- (NSString *)trimmingWhitespace;

- (NSString *)trimmingWhitespaceAndNewlines;
// 计算文本size
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize;

// 根据字体及行间距获取AttributedString
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace;
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize;
@end