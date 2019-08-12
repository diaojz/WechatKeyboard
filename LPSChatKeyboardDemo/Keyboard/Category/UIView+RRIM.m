//
//  UIView+RRIM.m
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import "UIView+RRIM.h"

@implementation UIView (RRIM)

- (CGFloat)rr_left
{
    return self.frame.origin.x;
}

- (void)setRr_left:(CGFloat)rr_left
{
    CGRect frame = self.frame;
    frame.origin.x = rr_left;
    self.frame = frame;
}

- (CGFloat)rr_top
{
    return self.frame.origin.y;
}

- (void)setRr_top:(CGFloat)rr_top
{
    CGRect frame = self.frame;
    frame.origin.y = rr_top;
    self.frame = frame;
}

- (CGFloat)rr_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRr_right:(CGFloat)rr_right
{
    CGRect frame = self.frame;
    frame.origin.x = rr_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)rr_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setRr_bottom:(CGFloat)rr_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = rr_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)rr_centerX
{
    return self.center.x;
}

- (void)setRr_centerX:(CGFloat)rr_centerX
{
    self.center = CGPointMake(rr_centerX, self.center.y);
}

- (CGFloat)rr_centerY
{
    return self.center.y;
}

- (void)setRr_centerY:(CGFloat)rr_centerY
{
    self.center = CGPointMake(self.center.x, rr_centerY);
}

- (CGFloat)rr_width
{
    return self.frame.size.width;
}

- (void)setRr_width:(CGFloat)rr_width
{
    CGRect frame = self.frame;
    frame.size.width = rr_width;
    self.frame = frame;
}

- (CGFloat)rr_height
{
    return self.frame.size.height;
}

- (void)setRr_height:(CGFloat)rr_height
{
    CGRect frame = self.frame;
    frame.size.height = rr_height;
    self.frame = frame;
}

- (CGPoint)rr_origin
{
    return self.frame.origin;
}

- (void)setRr_origin:(CGPoint)rr_origin
{
    CGRect frame = self.frame;
    frame.origin = rr_origin;
    self.frame = frame;
}

- (CGSize)rr_size
{
    return self.frame.size;
}

- (void)setRr_size:(CGSize)rr_size
{
    CGRect frame = self.frame;
    frame.size = rr_size;
    self.frame = frame;
}

@end
