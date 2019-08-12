//
//  RRVoiceRecordDefine.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/25.
//  Copyright © 2018年 renrui. All rights reserved.
//

#ifndef RRVoiceRecordDefine_h
#define RRVoiceRecordDefine_h

typedef NS_ENUM(NSInteger, RRVoiceRecordState)
{
    RRVoiceRecordStateNormal,          //初始状态
    RRVoiceRecordStateRecording,       //正在录音
    RRVoiceRecordStateReleaseToCancel, //上滑取消（也在录音状态，UI显示有区别）
    RRVoiceRecordStateRecordCounting,  //最后10s倒计时（也在录音状态，UI显示有区别）
    RRVoiceRecordStateRecordTooShort,  //录音时间太短（录音结束了）
    RRVoiceRecordStateStoped,          //录音结束
};

#endif /* RRVoiceRecordDefine_h */
