//
//  RRMorePanelView.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/19.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRMorePanelItem.h"

@interface RRMorePanelView : UIView

- (void)addMoreItem:(RRMorePanelItem *)item;

- (void)removeMoreItem:(RRMorePanelItem *)item;

- (void)addMoreContentView:(UIView *)plugin;

- (void)removeMoreContentView;

@end
