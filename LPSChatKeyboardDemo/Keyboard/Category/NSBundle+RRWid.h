//
//  NSBundle+RRWid.h
//  TFYT
//
//  Created by LiSiYuan on 2018/7/12.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (RRWid)
- (NSString *_Nullable)rr_pathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext;
@end
