//
//  RRVoiceRecordPowerAnimationView.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRVoiceRecordPowerAnimationView : UIView

@property (nonatomic, assign) CGSize originSize;

- (void)updateWithPower:(float)power;

@end
