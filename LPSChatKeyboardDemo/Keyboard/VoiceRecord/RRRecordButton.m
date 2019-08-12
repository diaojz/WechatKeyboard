//
//  RRRecordButton.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRRecordButton.h"

@implementation RRRecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit
{
//    self.exclusiveTouch = YES;
//    self.layoutType = WidButtonLayoutVertical;
//    self.imageAndTitleInset = 10;
//    self.imageSize = CGSizeMake(130, 130);
//    [self setImage:[UIImage imageNamed:@"voicebutton_normal"] forState:UIControlStateNormal];
//    [self setImage:[UIImage imageNamed:@"voicebutton_selected"] forState:UIControlStateSelected];
//    
//    self.titleLabel.font = JHFontSize15;
//    [self setTitle:@"长按录音" forState:UIControlStateNormal];
//    [self setTitleColor:[UIColor colorWithHexValue:0x999999] forState:UIControlStateNormal];
}

//- (void)updateRecordButtonStyle:(RRVoiceRecordState)state
//{
//
//}

@end
