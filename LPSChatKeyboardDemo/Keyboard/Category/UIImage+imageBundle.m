//
//  UIImage+imageBundle.m
//  RRIM_Example
//
//  Created by LiSiYuan on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#import "UIImage+imageBundle.h"

@implementation UIImage (imageBundle)
+(instancetype)imageWithBundleName:(NSString *)name
{
//    UIImage *image = [UIImage imageNamed:name];
//    return image;
    NSBundle *resourceBundle = nil;
    NSBundle *classBundle = [NSBundle mainBundle];
    NSURL *resourceBundleURL = [classBundle URLForResource:@"IMResource" withExtension:@"bundle"];
    if (resourceBundleURL) {
        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
    }
    else {
        resourceBundle = classBundle;
    }

    NSString *imagePath = [resourceBundle pathForResource:name ofType:@"png"];
    if (!imagePath) {
        name = [name stringByAppendingString:@"@2x"];
        imagePath = [resourceBundle pathForResource:name ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        return image;
    }
    return nil;
}
+(instancetype)imageWithFaceBundleName:(NSString *)name
{
//    NSBundle *resourceBundle = nil;
    NSBundle *classBundle = [NSBundle mainBundle];
//    NSURL *resourceBundleURL = [classBundle URLForResource:@"WXOUIModuleResources" withExtension:@"bundle"];
//    if (resourceBundleURL) {
//        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
//    }
//    else {
//        resourceBundle = classBundle;
//    }
    NSURL *faceURL = [classBundle URLForResource:@"WXOUIModuleResources" withExtension:@"bundle"];
    
    NSBundle *faceBundle = [[NSBundle alloc] initWithURL:faceURL];
    

    NSString *imagePath = [faceBundle pathForResource:name ofType:@"png"];
    if (!imagePath) {
        name = [name stringByAppendingString:@"@2x"];
        imagePath = [faceBundle pathForResource:name ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        return image;
    }
    return nil;
}
@end
