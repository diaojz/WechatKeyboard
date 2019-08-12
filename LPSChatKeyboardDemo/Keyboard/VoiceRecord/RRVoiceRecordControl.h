//
//  RRVoiceRecordControl.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRVoiceRecordDefine.h"

@interface RRVoiceRecordControl : NSObject

- (void)updateUIWithRecordState:(RRVoiceRecordState)state;
- (void)showToast:(NSString *)message complete:(void (^)())complete;
- (void)updatePower:(float)power;
- (void)showRecordCounting:(float)remainTime;

@end
