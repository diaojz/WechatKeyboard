//
//  RRPluginViewRecordView.m
//  JobHunter
//
//  Created by Daniel_Lee on 2019/5/27.
//  Copyright © 2019 renrui. All rights reserved.
//

#import "RRPluginViewRecordView.h"
#import <AVFoundation/AVFoundation.h>
#import "RRRecordButton.h"
#import "RRSoundRecorder.h"
#import "RRAudioPlayer.h"
#import "UIColor+RRIM.h"

#define kFakeTimerDuration       1
#define kMaxRecordDuration       60     //最长录音时长
#define kRemainCountingDuration  10     //剩余多少秒开始倒计时

@interface RRPluginViewRecordView ()

@property (nonatomic, strong) RRRecordButton *talkBtn;

@property (nonatomic, strong) NSTimer *fakeTimer;
@property (nonatomic, assign) RRVoiceRecordState currentRecordState;

@end

@implementation RRPluginViewRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor rr_colorWithHexValue:0xffffff];
        [self addSubview:self.talkBtn];
        [self addNotitications];
    }
    return self;
}

- (void)addNotitications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//退到后台，当前录制的语音直接发送
- (void)appDidEnterBackground {
    if ([RRSoundRecorder sharedInstance].isRecording) {
        [self.talkBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)applicationWillResignActive {
    if ([RRSoundRecorder sharedInstance].isRecording) {
        [self.talkBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)handleInterruption:(NSNotification *)notification {
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.talkBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - record
//开始录音
- (void)onClickRecordTouchDown:(UIButton *)button {
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        }];
    }
    else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {// 未授权
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
    }
    else{// 已授权
        self.currentRecordState = RRVoiceRecordStateNormal;
        [[RRAudioPlayer sharePlayer] stopAudioPlayer];
        [[RRSoundRecorder sharedInstance] startSoundRecord:[self recordPath]];
        [self startFakeTimer];
    }
}

- (NSString *)recordPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

- (BOOL)isAllowRecord {
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return (videoAuthStatus != AVAuthorizationStatusNotDetermined && videoAuthStatus != AVAuthorizationStatusRestricted && videoAuthStatus != AVAuthorizationStatusDenied);
}
//完成录音
- (void)onClickRecordTouchUpInside:(UIButton *)button {
    if ([[RRSoundRecorder sharedInstance] soundRecordTime] == 0) {//60s自动发送
        [[RRSoundRecorder sharedInstance] soundRecordFailed];
        self.currentRecordState = RRVoiceRecordStateStoped;
        [self stopFakeTimer];
        return;
    }
    if ([[RRSoundRecorder sharedInstance] soundRecordTime] < 1) {
        [self stopFakeTimer];
        self.talkBtn.selected = YES;
        self.talkBtn.userInteractionEnabled = NO;
        __weak typeof(self)ws = self;
        [[RRSoundRecorder sharedInstance] showShotTimeSignComplete:^{
            ws.talkBtn.selected = NO;
            ws.talkBtn.userInteractionEnabled = YES;
        }];
        self.currentRecordState = RRVoiceRecordStateRecordTooShort;
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVoiceInputAudioData:duration:)]) {
        NSTimeInterval recordTime = [RRSoundRecorder sharedInstance].soundRecordTime;
        [[RRSoundRecorder sharedInstance] stopSoundRecord];
        NSString *filePath = [RRSoundRecorder sharedInstance].soundFilePath;
        NSData *audioData = [NSData dataWithContentsOfFile:filePath];
        [self.delegate onVoiceInputAudioData:audioData duration:round(recordTime)];
    }
    //发送语音
    self.currentRecordState = RRVoiceRecordStateStoped;
    [[RRSoundRecorder sharedInstance] stopSoundRecord];
    [self stopFakeTimer];
}
//取消录音
- (void)onClickRecordTouchUpOutside:(UIButton *)button {
    self.currentRecordState = RRVoiceRecordStateStoped;
    [[RRSoundRecorder sharedInstance] soundRecordFailed];
    [self stopFakeTimer];
}
//继续录音
- (void)onClickRecordTouchDragEnter:(UIButton *)button {
    if (![self isAllowRecord]) {
        return;
    }
    self.currentRecordState = RRVoiceRecordStateRecording;
    [[RRSoundRecorder sharedInstance] resetNormalRecord];
}
//将要取消录音
- (void)onClickRecordTouchDragExit:(UIButton *)button {
    if (![self isAllowRecord]) {
        return;
    }
    self.currentRecordState = RRVoiceRecordStateReleaseToCancel;
    [[RRSoundRecorder sharedInstance] readyCancelSound];
}

- (void)startFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
    self.fakeTimer = [NSTimer scheduledTimerWithTimeInterval:kFakeTimerDuration target:self selector:@selector(onFakeTimerTimeOut) userInfo:nil repeats:YES];
}

- (void)stopFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
}

- (void)onFakeTimerTimeOut {
    NSTimeInterval recordTime = [[RRSoundRecorder sharedInstance] soundRecordTime];
    int countDown = round(kMaxRecordDuration - recordTime);
    if (countDown <= 10) {
        [[RRSoundRecorder sharedInstance] showCountdown:countDown < 0 ? 0 : countDown];
    }
    if (recordTime >= 1 && self.currentRecordState == RRVoiceRecordStateNormal) {
        self.currentRecordState = RRVoiceRecordStateRecording;
    }
    if (recordTime >= kMaxRecordDuration && recordTime <= kMaxRecordDuration + 1) {
        [self stopFakeTimer];
        [self.talkBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setCurrentRecordState:(RRVoiceRecordState)currentRecordState {
    _currentRecordState = currentRecordState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecordStateDidChanged:)]) {
        [self.delegate voiceRecordStateDidChanged:currentRecordState];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _talkBtn.centerX = self.width / 2;
    _talkBtn.centerY = self.height / 2;
}

- (RRRecordButton *)talkBtn {
    if (!_talkBtn) {
        _talkBtn = [[RRRecordButton alloc]initWithFrame:CGRectMake(0, 0, 130, 160)];
        [_talkBtn addTarget:self action:@selector(onClickRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_talkBtn addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_talkBtn addTarget:self action:@selector(onClickRecordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkBtn addTarget:self action:@selector(onClickRecordTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [_talkBtn addTarget:self action:@selector(onClickRecordTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    }
    return _talkBtn;
}

@end
