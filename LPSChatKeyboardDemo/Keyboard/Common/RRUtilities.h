//
//  RRUtilities.h
//  RRIM
//
//  Created by LiSiYuan on 2018/6/25.
//  Copyright © 2018 lsy0812@qq.com. All rights reserved.
//



@interface RRUtilities : NSObject
+ (UIViewController *_Nullable)getCurrentVC;
+ (UIView *_Nullable)alertView;
+ (CGFloat)topViewHeight;
/**
 十六进制字符串转换成十六进制数据

 @param hexString 十六进制字符串
 @return 十六进制数
 */
+ (NSInteger)numberWithHexString:(NSString *_Nullable)hexString;
+ (BOOL)checkCameraAuthorizationStatus;
@end
