//
//  RRVoiceRecordView.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRVoiceRecordDefine.h"
#import "RRVoiceRecordToastContentView.h"

@interface RRVoiceRecordView : UIView

- (void)updateUIWithRecordState:(RRVoiceRecordState)state;
- (void)updatePower:(float)power;
- (void)updateWithRemainTime:(float)remainTime;

@end
