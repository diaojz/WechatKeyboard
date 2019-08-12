//
//  RRPluginViewRecordView.h
//  JobHunter
//
//  Created by Daniel_Lee on 2019/5/27.
//  Copyright © 2019 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRVoiceRecordControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RRPluginViewRecordDelegate <NSObject>
@optional
/**
 *  发送语音消息
 *  audioData 语音数据
 *  duration  语音时长
 */
- (void)onVoiceInputAudioData:(NSData *)audioData duration:(NSInteger)duration;
/**
 *  当前录音状态
 */
- (void)voiceRecordStateDidChanged:(RRVoiceRecordState)recordState;

@end

@interface RRPluginViewRecordView : UIView

@property (nonatomic, weak) id<RRPluginViewRecordDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
