//
// Created by LiSiYuan on 2018/5/30.
// Copyright (c) 2018 renrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RRChatKeyBoardShowProtocol <NSObject>
@optional
-(CGFloat)toolBarheight;
-(BOOL)isInput;     //是否是弹出状态
@end