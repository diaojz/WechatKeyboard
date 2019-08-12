//
//  NSBundle+RRWid.m
//  TFYT
//
//  Created by LiSiYuan on 2018/7/12.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "NSBundle+RRWid.h"

@implementation NSBundle (RRWid)
- (NSString *)rr_pathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext
{
    NSBundle *resourceBundle = nil;
    NSURL *resourceBundleURL = [self URLForResource:@"WXOUIModuleResources" withExtension:@"bundle"];
    if (resourceBundleURL) {
        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
    }
    else {
        resourceBundle = self;
    }
    return [resourceBundle pathForResource:name ofType:ext];
    
}
@end
