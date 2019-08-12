//
// Created by LiSiYuan on 2018/5/30.
// Copyright (c) 2018 renrui. All rights reserved.
//

#import "RRChatKeyBoard+ShowSize.h"

@implementation RRChatKeyBoard (ShowSize)
- (CGFloat)toolBarheight
{
    return _topContainer.frame.size.height;
}

- (BOOL)isInput
{
    return [[UIScreen mainScreen] bounds].size.height - self.offset - self.frame.origin.y - _topContainer.frame.size.height != 0;
}

@end
