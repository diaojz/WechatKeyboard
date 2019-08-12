//
//  RRChatKeyBoard.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/18.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRMorePanelItem.h"
#import "RRVoiceRecordDefine.h"
#import "PPStickerTextView.h"

static const CGFloat kRRChatToolBarHeight = 49.0f;

@class RRChatKeyBoard;
typedef NS_ENUM(NSInteger, RRChatInputState)
{
    RRChatInputStateDefault,//默认状态，键盘未弹出
    RRChatInputStateFace,//表情输入状态
    RRChatInputStateMore,//显示更多面板状态
    RRChatInputStateKeyboard,//键盘弹出状态
};

@protocol RRChatKeyBoardDelegate <NSObject>
@optional
- (void)changeStateKeyboard:(CGFloat)chatKeyboardY;
/**
 *  发送输入框中的文字
 */
- (void)stickerInputViewDidClickSendButton:(RRChatKeyBoard *_Nullable)inputView;

@end

@interface RRChatKeyBoard : UIView
{
@protected
    UIView *_topContainer;
    UIView *_bottomCotainer;
}

/**
 * 键盘收起
 */
- (void)hideKeyBoard;
/**
 * 弹出键盘
 */
- (void)showKeyBoard;

@property (nonatomic, weak) id<RRChatKeyBoardDelegate> _Nullable delegate;

@property (nonatomic, assign) NSInteger maxVisibleLine;
@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, assign) CGFloat offset;//y坐标偏移量
@property (nonatomic, strong, readonly) NSString * _Nullable plainText;//获取输入框中的文字
@property (nonatomic, strong) NSString * _Nullable draftString;//传入草稿文字，会默认显示在输入框中
@property (nonatomic, strong, readonly) PPStickerTextView * _Nullable textView;
@property (nonatomic, assign) RRChatInputState state;
- (void)keyboardStateChanged:(void(^_Nullable)(RRChatInputState state))keyboardState;

/**
 *  语音输入功能开关，默认 NO，即默认打开语音输入
 */
//@property (nonatomic, assign, readwrite) BOOL disableAudioInput;
/**
 *  添加更多面板的按钮
 */
- (void)addMoreItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName handler:(void(^_Nullable)(void))handler;
/**
 *  需要先设置disableAudioInput为YES，再添加输入框左侧按钮，左侧只可以添加一个按钮
 */
- (void)addLeftPluginViewWithButton:(UIButton *_Nullable)button handler:(void(^_Nullable)(void))handler;
/**
 *  在更多面板上添加视图
 */
- (void)addMorePanelContentView:(UIView *_Nullable)plugin;

@end
