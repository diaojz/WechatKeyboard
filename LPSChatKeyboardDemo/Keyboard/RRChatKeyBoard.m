//
//  RRChatKeyBoard.m
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/18.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import "RRChatKeyBoard.h"
#import "RRMorePanelView.h"
#import "PPStickerKeyboard.h"
#import "PPUtil.h"
#import "RRRecordButton.h"
#import "PPStickerDataManager.h"
#import "RRAudioPlayer.h"
#import "RRSoundRecorder.h"
#import "RRIM.h"
#import "UIView+RRIM.h"
#import "RRHeader.h"
#import "RRUtilities.h"
#import "LPSUtilities.h"

const CGFloat kMoreViewHeight = 216;
const CGFloat kFaceViewHeight = 216;

#define kItemIconWidth   38
#define kBtnSpace        8

#define kTextViewHeight  36
#define kTextViewOriginY (kRRChatToolBarHeight - kTextViewHeight) / 2

@interface RRChatKeyBoard ()<UITextViewDelegate, PPStickerKeyboardDelegate>

@property (nonatomic, strong) UIView *topContainer;//上侧容器
@property (nonatomic, strong) UIView *bottomCotainer;//下方容器

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) PPStickerTextView *textView;

@property (nonatomic, strong) RRMorePanelView *moreView;
@property (nonatomic, strong) PPStickerKeyboard *faceView;

@property (nonatomic, assign) CGFloat keyboardY;

@property (nonatomic, copy) void (^ leftActionBlock)(void);
@property (nonatomic, strong) UIButton *leftPluginButton;
@property (nonatomic, copy) void (^ keyboardBlock)(RRChatInputState state);

@end

@implementation RRChatKeyBoard

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor rr_colorWithHexValue:0xffffff];
        self.state = RRChatInputStateDefault;
        self.maxVisibleLine = 5;
        [self.textView resignFirstResponder];
        [self setUpUI];
        [self addNotification];
    }

    return self;
}

- (void)hideKeyBoard {
    self.state = RRChatInputStateDefault;
    [self.textView resignFirstResponder];
}

- (void)showKeyBoard {
    self.state = RRChatInputStateKeyboard;
    [self.textView becomeFirstResponder];
}

- (void)setDraftString:(NSString *)draftString {
    _draftString = draftString;
    if (draftString.length > 0) {
        self.state = RRChatInputStateKeyboard;
        [self.textView becomeFirstResponder];
        self.textView.text = draftString;
        [self textViewDidChange:self.textView];
    }
}

- (void)addMoreItemWithTitle:(NSString *)title imageName:(NSString *)imageName handler:(void (^)(void))handler
{
    RRMorePanelItem *item = [RRMorePanelItem createMoreItemWithTitle:title imageName:imageName handler:handler];
    [self.moreView addMoreItem:item];
}

- (void)addMorePanelContentView:(UIView *)plugin {
    [self.moreView addMoreContentView:plugin];
}

- (void)addLeftPluginViewWithButton:(UIButton *)button handler:(void (^)(void))handler
{
    if (button != nil) {
        _leftActionBlock = handler;
        self.leftPluginButton = button;
        [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [button addTarget:self action:@selector(leftPluginViewClicked) forControlEvents:UIControlEventTouchUpInside];
        if (self.leftPluginButton.superview) {
            [self.leftPluginButton removeFromSuperview];
        }
        [self.topContainer addSubview:self.leftPluginButton];
        [self layoutSubViewFrame];
    }
}

#pragma mark---添加子视图---
- (void)setUpUI {
    [self addSubview:self.topContainer];
    [self addSubview:self.bottomCotainer];
    [self.topContainer addSubview:self.topLine];
    [self.topContainer addSubview:self.faceBtn];
    [self.topContainer addSubview:self.moreBtn];
    [self.topContainer addSubview:self.textView];
}

- (void)keyboardStateChanged:(void (^)(RRChatInputState state))keyboardBlock {
    _keyboardBlock = keyboardBlock;
}

#pragma mark--设置是否有动画 （一体键盘）
- (void)setIsDisappear:(BOOL)isDisappear {
    _isDisappear = isDisappear;
}

#pragma mark---textview---
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.state != RRChatInputStateKeyboard) {
        self.state = RRChatInputStateKeyboard;
    }
    [self changeFrame:ceilf ([textView sizeThatFits:textView.frame.size].height)];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
    [self changeFrame:ceilf ([textView sizeThatFits:textView.frame.size].height)];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

- (NSString *)plainText {
    return [self.textView.attributedText pp_plainTextForRange:NSMakeRange (0, self.textView.attributedText.length)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(stickerInputViewDidClickSendButton:)]) {
                [self.delegate stickerInputViewDidClickSendButton:self];
            }
        }
        self.textView.text = @"";
        self.textView.rr_height = kTextViewHeight;
        [self textViewDidChange:self.textView];
        return NO;
    }

    return YES;
}

- (void)changeFrame:(CGFloat)height {
    CGFloat maxHeight = 0;
    if (self.maxVisibleLine) {
        maxHeight = ceil (self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    if (height < kTextViewHeight) {
        height = kTextViewHeight;
    }
    self.textView.scrollEnabled = height > maxHeight && maxHeight > 0;
    if (self.textView.scrollEnabled) {
        height = 5 + maxHeight;
    } else {
        height = height;
    }
    CGFloat textviewH = height;

    __block CGFloat totalH = 0;
    if (self.state == RRChatInputStateFace || self.state == RRChatInputStateMore) {
        [UIView animateWithDuration:.25 animations:^{
            totalH = height + kTextViewOriginY * 2 + kFaceViewHeight + [LPSUtilities layoutSafeBottom];
            if (self->_keyboardY == 0) {
                self->_keyboardY = ScreenHeight - self.offset;
            }
            self.rr_top = self->_keyboardY - totalH;
            self.rr_height = totalH;

            self.topContainer.rr_height = height + kTextViewOriginY * 2;
            self.bottomCotainer.rr_top = self.topContainer.rr_height;
            self.textView.rr_top = kTextViewOriginY;
            self.textView.rr_height = textviewH;

            self.moreBtn.rr_top =  self.faceBtn.rr_top = totalH - kTextViewOriginY - kItemIconWidth - kFaceViewHeight - [LPSUtilities layoutSafeBottom];
        }];
    } else {
        [UIView animateWithDuration:.25 animations:^{
            totalH = height + kTextViewOriginY * 2;
            if (self->_keyboardY == 0) {
                self->_keyboardY = ScreenHeight - self.offset;
            }
            self.rr_top = self->_keyboardY - totalH;
            self.rr_height = totalH;
            self.topContainer.rr_height = totalH;

            self.textView.rr_top = kTextViewOriginY;
            self.textView.rr_height = textviewH;
            self.bottomCotainer.rr_top = self.topContainer.rr_height;

            self.moreBtn.rr_top = self.faceBtn.rr_top = totalH - kTextViewOriginY - kItemIconWidth;
            self.leftPluginButton.rr_top = totalH - kTextViewOriginY - kItemIconWidth;
        }];
    }

    if ([self.delegate respondsToSelector:@selector(changeStateKeyboard:)]) {
        [self.delegate changeStateKeyboard:self.rr_top];
    }

    [self.textView scrollRangeToVisible:NSMakeRange (0, self.textView.text.length)];
}

- (void)setMaxVisibleLine:(NSInteger)maxVisibleLine {
    _maxVisibleLine = maxVisibleLine;
}

#pragma mark action

- (void)leftPluginViewClicked
{
    if (self.leftActionBlock) {
        self.leftActionBlock ();
    }
}

- (void)onFaceBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    self.moreBtn.selected = NO;
    if (!self.faceView.superview) {
        [self.bottomCotainer addSubview:self.faceView];
    }
    self.state = (button.selected ? RRChatInputStateFace : RRChatInputStateKeyboard);
    if (self.state == RRChatInputStateKeyboard) {
        [self.textView becomeFirstResponder];
    } else {
        if (self.textView.isFirstResponder) {
            [self.textView resignFirstResponder];
        }
    }
}

- (void)onMoreBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    self.faceBtn.selected = NO;
    if (!self.moreView.superview) {
        [self.bottomCotainer addSubview:self.moreView];
    }
    self.state = (button.selected ? RRChatInputStateMore : RRChatInputStateKeyboard);
    if (self.state == RRChatInputStateKeyboard) {
        [self.textView becomeFirstResponder];
    } else {
        if (self.textView.isFirstResponder) {
            [self.textView resignFirstResponder];
        }
    }
}

- (void)refreshMoreView:(RRChatInputState)state {
    if (state != RRChatInputStateMore) {
        [self.moreView removeMoreContentView];
    }
}

- (void)setState:(RRChatInputState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    [self refreshMoreView:state];
    switch (state) {
        case RRChatInputStateDefault: {
            self.faceView.hidden = self.moreView.hidden = YES;
            self.faceBtn.selected = self.moreBtn.selected = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0, ScreenHeight - self.offset - self.textView.rr_height - 2 * kTextViewOriginY - [LPSUtilities layoutSafeBottom], ScreenWidth, self.textView.rr_height + 2 * kTextViewOriginY);
            }];
        }
        break;
        case RRChatInputStateKeyboard: {
            self.moreView.hidden = YES;
            if (_faceView.superview) {
                self.faceView.hidden = YES;
            }
            self.textView.hidden = NO;
            self.faceBtn.selected = NO;

            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0, self.rr_top, ScreenWidth, self.textView.rr_height + 2 * kTextViewOriginY);
            }];
        }
        break;
        case RRChatInputStateFace: {
            self.moreView.hidden = YES;
            self.faceView.hidden = NO;
            self.textView.hidden = NO;
            [UIView animateWithDuration:.25 animations:^{
                self.rr_height = self.textView.rr_height + 2 * kTextViewOriginY + kFaceViewHeight + [LPSUtilities layoutSafeBottom];
                self.rr_top = ScreenHeight - self.offset - self.rr_height;
                self.bottomCotainer.rr_top = self.textView.rr_height + 2 * kTextViewOriginY;
            }];
        }
        break;
        case RRChatInputStateMore: {
            self.textView.hidden = NO;
            self.moreView.hidden = NO;
            self.faceView.hidden = YES;
            [UIView animateWithDuration:.25 animations:^{
                self.rr_height = self.textView.rr_height + 2 * kTextViewOriginY + kFaceViewHeight + [LPSUtilities layoutSafeBottom];
                self.rr_top = ScreenHeight - self.offset - self.rr_height;
                self.bottomCotainer.rr_top = self.textView.rr_height + 2 * kTextViewOriginY;
            }];
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(changeStateKeyboard:)]) {
        [self.delegate changeStateKeyboard:self.rr_top];
    }
    if (self.keyboardBlock) {
        self.keyboardBlock (state);
    }
}

- (void)layoutSubViewFrame {
//    if (self.disableAudioInput) {
    CGSize leftPluginSize = self.leftPluginButton.rr_size;
    self.leftPluginButton.frame = CGRectMake (kBtnSpace, (kRRChatToolBarHeight - leftPluginSize.height) / 2, leftPluginSize.width, leftPluginSize.height);
    self.textView.frame = CGRectMake (2 * kBtnSpace + leftPluginSize.width, kTextViewOriginY, ScreenWidth - leftPluginSize.width - 2 * kItemIconWidth - 4 * kBtnSpace, kTextViewHeight);
    self.faceBtn.frame = CGRectMake (ScreenWidth - 2 * kItemIconWidth - kBtnSpace, (kRRChatToolBarHeight - kItemIconWidth) / 2, kItemIconWidth, kItemIconWidth);
    self.moreBtn.frame = CGRectMake (ScreenWidth - kItemIconWidth - kBtnSpace, (kRRChatToolBarHeight - kItemIconWidth) / 2, kItemIconWidth, kItemIconWidth);
//    }
}

#pragma mark--添加通知---
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (self.rr_height == 0) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardY = keyboardF.origin.y - self.offset;
    if (self.state == RRChatInputStateMore || self.state == RRChatInputStateFace) {
        return;
    }

    if (!_isDisappear) {
        [UIView animateWithDuration:duration animations:^{
            if (keyboardF.origin.y > (ScreenHeight - self.offset)) {
                self.rr_top = ScreenHeight - self.offset - self.rr_height - [LPSUtilities layoutSafeBottom];
                if (self.state != RRChatInputStateDefault) {
                    self.state = RRChatInputStateDefault;
                }
            } else {
                self.rr_top = keyboardF.origin.y - self.offset - self.rr_height;
            }
        }];
        if ([self.delegate respondsToSelector:@selector(changeStateKeyboard:)]) {
            [self.delegate changeStateKeyboard:self.rr_top];
        }
    }
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    if (_isDisappear) {//一体键盘，在控制器手势返回时，键盘高度保持不变
        if (self.state != RRChatInputStateKeyboard) {
            return;
        }
        NSDictionary *userInfo = notification.userInfo;
        CGRect keyboardF = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        if (keyboardF.origin.y > (ScreenHeight - self.offset)) {
            self.rr_top = ScreenHeight - self.offset - self.rr_height - [LPSUtilities layoutSafeBottom];
        } else {
            self.rr_top = keyboardF.origin.y - self.offset - self.rr_height;
        }
    }
}

- (void)stickerKeyboard:(PPStickerKeyboard *)stickerKeyboard didClickEmoji:(PPEmoji *)emoji
{
    if (!emoji) {
        return;
    }

    UIImage *emojiImage = [UIImage imageWithFaceBundleName:emoji.imageName];
    if (!emojiImage) {
        return;
    }

    NSRange selectedRange = self.textView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"%@", emoji.emojiDescription];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor pp_colorWithRGBString:@"#3B3B3B"] }];
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textView.attributedText = attributedText;
    self.textView.selectedRange = NSMakeRange (selectedRange.location + emojiAttributedString.length, 0);

    [self textViewDidChange:self.textView];
}

- (void)stickerKeyboardDidClickDeleteButton:(PPStickerKeyboard *)stickerKeyboard
{
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange (selectedRange.location, 0);
    } else {
        [attributedText deleteCharactersInRange:NSMakeRange (selectedRange.location - 1, 1)];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange (selectedRange.location - 1, 0);
    }

    [self textViewDidChange:self.textView];
}

- (void)stickerKeyboardDidClickSendButton:(PPStickerKeyboard *)stickerKeyboard
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerInputViewDidClickSendButton:)]) {
        [self.delegate stickerInputViewDidClickSendButton:self];
    }
    self.textView.text = @"";
    self.textView.rr_height = kTextViewHeight;
    [self textViewDidChange:self.textView];
}

#pragma mark - getter
- (UIView *)topContainer {
    if (!_topContainer) {
        _topContainer = [[UIView alloc]initWithFrame:CGRectMake (0, 0, ScreenWidth, kRRChatToolBarHeight)];
        _topContainer.backgroundColor = [UIColor rr_colorWithHexValue:0xffffff];
    }
    return _topContainer;
}

- (UIView *)bottomCotainer {
    if (!_bottomCotainer) {
        _bottomCotainer = [[UIView alloc]initWithFrame:CGRectMake (0, kRRChatToolBarHeight, ScreenWidth, kFaceViewHeight + [LPSUtilities layoutSafeBottom])];
        _bottomCotainer.backgroundColor = [UIColor rr_colorWithHexValue:0xffffff];
    }
    return _bottomCotainer;
}

- (RRMorePanelView *)moreView {
    if (!_moreView) {
        _moreView = [[RRMorePanelView alloc] initWithFrame:CGRectMake (0, 0, ScreenWidth, kMoreViewHeight)];
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectMake (0, 0, self.rr_width, 1 / [UIScreen mainScreen].scale)];
        [_topLine setBackgroundColor:[UIColor rr_colorWithHexValue:0xd8d7d9]];
    }
    return _topLine;
}

- (UIButton *)faceBtn {
    if (!_faceBtn) {
        _faceBtn = [[UIButton alloc] initWithFrame:CGRectMake (ScreenWidth - 2 * kItemIconWidth - kBtnSpace, (kRRChatToolBarHeight - kItemIconWidth) / 2, kItemIconWidth, kItemIconWidth)];
        [_faceBtn setImage:[UIImage imageWithBundleName:@"face_normal"] forState:UIControlStateNormal];
        [_faceBtn setImage:[UIImage imageWithBundleName:@"keyboard_normal"] forState:UIControlStateSelected];
        [_faceBtn addTarget:self action:@selector(onFaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake (ScreenWidth - kItemIconWidth - kBtnSpace, (kRRChatToolBarHeight - kItemIconWidth) / 2, kItemIconWidth, kItemIconWidth)];
        [_moreBtn setImage:[UIImage imageWithBundleName:@"more_normal"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageWithBundleName:@"more_pressed"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (PPStickerTextView *)textView {
    if (!_textView) {
        _textView = [[PPStickerTextView alloc] initWithFrame:CGRectMake (kItemIconWidth + 2 * kBtnSpace, (kRRChatToolBarHeight - kTextViewHeight) / 2, ScreenWidth - 3 * kItemIconWidth - 4 * kBtnSpace, kTextViewHeight)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor rr_colorWithHexValue:0xf6f6f6];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.placeholderColor = [UIColor rr_colorWithHexValue:0x999999];
        _textView.placeholder = @" 想对Ta说点什么？";
        _textView.verticalCenter = YES;
        _textView.enablesReturnKeyAutomatically = YES;
        if (@available(iOS 11.0, *)) {
            _textView.textDragInteraction.enabled = NO;
        }
    }
    return _textView;
}

- (PPStickerKeyboard *)faceView {
    if (!_faceView) {
        _faceView = [[PPStickerKeyboard alloc] initWithFrame:CGRectMake (0, 0, ScreenWidth, kMoreViewHeight)];
        _faceView.delegate = self;
        _faceView.hidden = YES;
    }
    return _faceView;
}

@end
