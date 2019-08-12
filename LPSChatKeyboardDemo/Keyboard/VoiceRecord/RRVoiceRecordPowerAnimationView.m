//
//  RRVoiceRecordPowerAnimationView.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRVoiceRecordPowerAnimationView.h"

@interface RRVoiceRecordPowerAnimationView ()

@property (nonatomic, strong) UIImageView *imgContent;
//@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation RRVoiceRecordPowerAnimationView

- (void)updateWithPower:(float)power
{
    if (_imgContent == nil) {
        self.imgContent = [UIImageView new];
        _imgContent.backgroundColor = [UIColor clearColor];
        _imgContent.image = [UIImage imageNamed :@"yuyin1"];
        [self addSubview:_imgContent];
    }
    _imgContent.frame = CGRectMake(0, 0, _originSize.width, _originSize.height);
    
    int viewCount = ceil(fabs(power)*10);
    if (viewCount == 0) {
        viewCount++;
    }
    if (viewCount > 10) {
        viewCount = 10;
    }
    int num = (viewCount+1)/2;
    _imgContent.image = [UIImage imageNamed:[NSString stringWithFormat:@"yuyin%d",num]];
//    if (_maskLayer == nil) {
//        self.maskLayer = [CAShapeLayer new];
//        _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//    }
    
//    CGFloat itemHeight = 7;
//    CGFloat itemPadding = 7.4;
//    CGFloat maskPadding = itemHeight*viewCount + (viewCount-1)*itemPadding;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, _originSize.height - maskPadding, _originSize.width, _originSize.height)];
//    _maskLayer.path = path.CGPath;
//    _imgContent.layer.mask = _maskLayer;
    
}

@end
