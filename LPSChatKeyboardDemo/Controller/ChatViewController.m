//
//  ChatViewController.m
//  LPSChatKeyboardDemo
//
//  Created by Daniel_Lee on 2019/8/12.
//  Copyright © 2019 renrui. All rights reserved.
//

#import "ChatViewController.h"
#import "RRChatKeyBoard.h"
#import "LPSUtilities.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, RRChatKeyBoardDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RRChatKeyBoard *keyBoard;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ChatViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-(kRRChatToolBarHeight+[LPSUtilities layoutSafeBottom]));
    
    self.keyBoard.offset = 0;
    self.keyBoard.frame = CGRectMake(0, self.tableView.bottom, ScreenWidth, kRRChatToolBarHeight+[LPSUtilities layoutSafeBottom]);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyBoard];
    [self loadData];
}

#pragma mark - Methods
- (void)loadData {
    NSArray *data = @[@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1"];
    [self.dataArray addObjectsFromArray:data];
    
    [self refreshUI];
}

- (void)refreshUI {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"chat";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *str = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.keyBoard hideKeyBoard];
}

#pragma mark - RRChatKeyBoardDelegate
/// 发送输入框中的文字n
- (void)stickerInputViewDidClickSendButton:(RRChatKeyBoard *_Nullable)inputView {
    [self.dataArray addObject:inputView.plainText];
    [self.tableView reloadData];
}

#pragma mark - Property
- (UITableView *)tableView {
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor orangeColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (RRChatKeyBoard *)keyBoard {
    if (!_keyBoard){
        _keyBoard = [[RRChatKeyBoard alloc] initWithFrame:CGRectZero];
        _keyBoard.delegate = self;
        [_keyBoard addMoreItemWithTitle:@"照片" imageName:@"input_plug_ico_photo_nor" handler:^{
            
        }];
        [_keyBoard addMoreItemWithTitle:@"拍摄" imageName:@"input_plug_ico_camera_nor" handler:^{
            
        }];
        [_keyBoard addMoreItemWithTitle:@"位置" imageName:@"input_plug_ico_ad_nor" handler:^{
            
        }];
    }
    return _keyBoard;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
