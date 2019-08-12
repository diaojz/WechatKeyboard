//
//  RRVoiceRecordToastContentView.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRVoiceRecordToastContentView.h"
#import "RRVoiceRecordPowerAnimationView.h"

@implementation RRVoiceRecordToastContentView

@end

//----------------------------------------//
@interface RRVoiceRecordingView ()

@property (nonatomic, strong) UIImageView *imgRecord;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) RRVoiceRecordPowerAnimationView *powerView;

@end

@implementation RRVoiceRecordingView

- (void)dealloc
{
    //
}

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
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        _contentLabel.backgroundColor = [UIColor clearColor];
//        _contentLabel.text = @"上滑取消发送";
//        _contentLabel.textColor = [UIColor whiteColor];
//        _contentLabel.textAlignment = NSTextAlignmentCenter;
//        _contentLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_contentLabel];
//    }
//    if (!_imgRecord) {
//        _imgRecord = [UIImageView new];
//        _imgRecord.backgroundColor = [UIColor clearColor];
//        _imgRecord.image = [UIImage imageNamed:@"ic_record"];
//        [self addSubview:_imgRecord];
//    }
    if (!_powerView) {
        _powerView = [RRVoiceRecordPowerAnimationView new];
        _powerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_powerView];
    }
    
    CGSize powerSize = CGSizeMake(105, 105);
    //默认显示一格音量
    _powerView.originSize = powerSize;
    [_powerView updateWithPower:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize textSize = [_contentLabel sizeThatFits:CGSizeZero];
//    self.contentLabel.frame = CGRectMake(0, 0, self.width, ceil(textSize.height));
//    self.contentLabel.bottom = self.height - 12;
//    self.imgRecord.frame = CGRectMake(30, 28, _imgRecord.image.size.width, _imgRecord.image.size.height);
//    CGSize powerSize = CGSizeMake(16, 37);
//    self.powerView.frame = CGRectMake(_imgRecord.right+4, 0, powerSize.width, powerSize.height);
//    self.powerView.bottom = self.imgRecord.bottom;
    self.powerView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)updateWithPower:(float)power
{
    [_powerView updateWithPower:power];
}

@end

//----------------------------------------//
@interface RRVoiceRecordReleaseToCancelView ()

@property (nonatomic, strong) UIImageView *imgRelease;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RRVoiceRecordReleaseToCancelView

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
    if (!_imgRelease) {
        _imgRelease = [UIImageView new];
        _imgRelease.backgroundColor = [UIColor clearColor];
        _imgRelease.image = [UIImage imageNamed:@"ic_releasecancel"];
        [self addSubview:_imgRelease];
    }
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        _contentLabel.text = @"松开取消发送";
//        _contentLabel.textColor = [UIColor colorWithHexValue:0xffffff];
//        _contentLabel.textAlignment = NSTextAlignmentCenter;
//        _contentLabel.font = [UIFont boldSystemFontOfSize:15];
//        _contentLabel.layer.cornerRadius = 2;
//        _contentLabel.clipsToBounds = YES;
//        [self addSubview:_contentLabel];
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.imgRelease.frame = CGRectMake(0, 30, _imgRelease.image.size.width, _imgRelease.image.size.height);
//    self.imgRelease.centerX = self.width / 2;
    self.imgRelease.frame = self.bounds;
    self.contentLabel.frame = CGRectMake(3, 0, self.width-6, 25);
    self.contentLabel.bottom = self.height - kDefaultInsetX;
}

@end

//----------------------------------------//
@interface RRVoiceRecordCountingView ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *lbRemainTime;

@end

@implementation RRVoiceRecordCountingView

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
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = @"上滑取消发送";
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        //        _contentLabel.layer.cornerRadius = 2;
        //        _contentLabel.clipsToBounds = YES;
        [self addSubview:_contentLabel];
    }
    if (!_lbRemainTime) {
        _lbRemainTime = [UILabel new];
        _lbRemainTime.backgroundColor = [UIColor clearColor];
        _lbRemainTime.font = [UIFont systemFontOfSize:60];
        _lbRemainTime.textColor = [UIColor whiteColor];
        [self addSubview:_lbRemainTime];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(3, 0, self.width - 6, 25);
    self.contentLabel.bottom = self.height - 8;
    CGSize textSize = [_lbRemainTime sizeThatFits:CGSizeZero];
    self.lbRemainTime.frame = CGRectMake(0, 8, ceil(textSize.width), [UIFont systemFontOfSize:60].lineHeight);
    self.lbRemainTime.centerX = self.width / 2;
}

- (void)updateWithRemainTime:(float)remainTime
{
    _lbRemainTime.text = [NSString stringWithFormat:@"%d",(int)remainTime];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end

//----------------------------------------//
@interface RRVoiceRecordTipView ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RRVoiceRecordTipView

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
    self.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.5];
    self.layer.cornerRadius = 6;
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.text = @"说话时间太短";
        [self addSubview:_contentLabel];
    }
    if (!_imgIcon) {
        _imgIcon = [UIImageView new];
        _imgIcon.backgroundColor = [UIColor clearColor];
        _imgIcon.image = [UIImage imageNamed:@"ic_shuohuashijiantaiduan_liaotianshi"];
        [self addSubview:_imgIcon];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgIcon.frame = CGRectMake(0, 15, _imgIcon.image.size.width, _imgIcon.image.size.height);
    self.imgIcon.centerX = self.width / 2;
    CGSize textSize = [_contentLabel sizeThatFits:CGSizeZero];
    self.contentLabel.frame = CGRectMake(0, 0, self.width, ceil(textSize.height));
    self.contentLabel.bottom = self.height - 12;
}

- (void)showWithMessage:(NSString *)msg
{
    _contentLabel.text = msg;
}

@end
