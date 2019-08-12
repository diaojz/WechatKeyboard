//
//  UIImage+RRIM.h
//  RRIM_Example
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RRIM)

+ (UIImage *)rr_imageWithColor:(UIColor *)color;

+ (UIImage *)rr_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)rr_stretchableImage;

+ (UIImage *)rr_stretchableImageNamed:(NSString *)name;

- (UIImage *)rr_scaleToSize:(CGSize)reSize;

// 修正图片旋转方向，兼容非ios系统，避免上传的本地图片在服务端或其他客户端旋转方向错误
// ios照片，即使倒着拍照，显示的时候也是正的，但上传服务器后显示的是倒立的
- (UIImage *)rr_fixOrientation;
@end
