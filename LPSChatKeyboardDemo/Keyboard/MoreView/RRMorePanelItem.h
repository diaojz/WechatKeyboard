//
//  RRMorePanelItem.h
//  JobHunter
//
//  Created by Daniel_Lee on 2018/5/19.
//  Copyright © 2018年 renrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRMorePanelItem : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, copy) void (^handler) (void);

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (RRMorePanelItem *)createMoreItemWithTitle:(NSString *)title imageName:(NSString *)imageName handler:(void(^)(void))handler;

@end
