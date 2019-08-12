//
//  RRHeader.h
//  RRIM
//
//  Created by Daniel_Lee on 2018/6/25.
//  Copyright © 2018年 lsy0812@qq.com. All rights reserved.
//

#ifndef RRHeader_h
#define RRHeader_h

#define ScreenWidth                             [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                            [[UIScreen mainScreen] bounds].size.height

#define kTopViewContentOriginY  20
#define kTopViewContentHeight   44
#define kTopViewHeight (kTopViewContentOriginY + kTopViewContentHeight)

#define kTextFieldLeftViewSize 15

#define kXTopViewContentOriginY 44

#define kXTopViewHeight (kXTopViewContentOriginY + kTopViewContentHeight)

#define kTabBarHeight 49

#define kXTopSafeHeight 24
#define kXTabBarSafeHeight 34

#define kXTabBarHeight (kTabBarHeight + kXTabBarSafeHeight)

#endif /* RRHeader_h */
