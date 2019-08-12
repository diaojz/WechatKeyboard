//
//  RRVoiceRecordToastContentView.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRVoiceRecordToastContentView : UIView

@end

@interface RRVoiceRecordingView : RRVoiceRecordToastContentView

- (void)updateWithPower:(float)power;

@end

//----------------------------------------//
@interface RRVoiceRecordReleaseToCancelView : RRVoiceRecordToastContentView


@end

//----------------------------------------//

@interface RRVoiceRecordCountingView : RRVoiceRecordToastContentView

- (void)updateWithRemainTime:(float)remainTime;

@end

//----------------------------------------//
@interface RRVoiceRecordTipView : RRVoiceRecordToastContentView

- (void)showWithMessage:(NSString *)msg;

@end
