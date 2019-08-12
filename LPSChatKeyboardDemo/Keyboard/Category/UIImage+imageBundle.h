//
//  UIImage+imageBundle.h
//  RRIM_Example
//
//  Created by LiSiYuan on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageBundle)
+(instancetype)imageWithBundleName:(NSString *)name;
+(instancetype)imageWithFaceBundleName:(NSString *)name;
@end
