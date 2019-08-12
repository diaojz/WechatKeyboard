//
//  RRVoiceRecordView.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRVoiceRecordView.h"
//#import "RRIM.h"

@interface RRVoiceRecordView ()

@property (nonatomic, strong) RRVoiceRecordingView *recodingView;
@property (nonatomic, strong) RRVoiceRecordReleaseToCancelView *releaseToCancelView;
@property (nonatomic, strong) RRVoiceRecordCountingView *countingView;
@property (nonatomic, assign) RRVoiceRecordState currentState;

@end

@implementation RRVoiceRecordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    if (!_recodingView) {
        self.recodingView = [[RRVoiceRecordingView alloc] initWithFrame:self.bounds];
        [self addSubview:_recodingView];
        _recodingView.hidden = YES;
    }
    
    if (!_releaseToCancelView) {
        self.releaseToCancelView = [[RRVoiceRecordReleaseToCancelView alloc] initWithFrame:self.bounds];
        [self addSubview:_releaseToCancelView];
        _releaseToCancelView.hidden = YES;
    }
    
    if (!_countingView) {
        self.countingView = [[RRVoiceRecordCountingView alloc] initWithFrame:self.bounds];
        [self addSubview:_countingView];
        _countingView.hidden = YES;
    }
    
    self.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.5];
    self.layer.cornerRadius = 6;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _recodingView.frame = self.bounds;
    _releaseToCancelView.frame = self.bounds;
    _countingView.frame = self.bounds;
}

- (void)updatePower:(float)power
{
    if (_currentState != RRVoiceRecordStateRecording) {
        return;
    }
    [_recodingView updateWithPower:power];
}

- (void)updateWithRemainTime:(float)remainTime
{
    if (_currentState != RRVoiceRecordStateRecordCounting || _releaseToCancelView.hidden == NO) {
        return;
    }
    [_countingView updateWithRemainTime:remainTime];
}

- (void)updateUIWithRecordState:(RRVoiceRecordState)state
{
    self.currentState = state;
    if (state == RRVoiceRecordStateNormal || state == RRVoiceRecordStateStoped) {
        _recodingView.hidden = YES;
        _releaseToCancelView.hidden = YES;
        _countingView.hidden = YES;
    }
    else if (state == RRVoiceRecordStateRecording)
    {
        _recodingView.hidden = NO;
        _releaseToCancelView.hidden = YES;
        _countingView.hidden = YES;
    }
    else if (state == RRVoiceRecordStateReleaseToCancel)
    {
        _recodingView.hidden = YES;
        _releaseToCancelView.hidden = NO;
        _countingView.hidden = YES;
    }
    else if (state == RRVoiceRecordStateRecordCounting)
    {
        _recodingView.hidden = YES;
        _releaseToCancelView.hidden = YES;
        _countingView.hidden = NO;
    }
    else if (state == RRVoiceRecordStateRecordTooShort)
    {
        _recodingView.hidden = YES;
        _releaseToCancelView.hidden = YES;
        _countingView.hidden = YES;
    }
}

@end
