//
//  OnRouteRightItemsView.h
//  mckfc
//
//  Created by zc on 2017/8/28.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol didClickMenuDelegate <NSObject>
@optional
-(void)exitView;
-(void)callPhone;

@end

@interface OnRouteRightItemsView : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<didClickMenuDelegate> menuDelegate;
@property (nonatomic, strong) UITableView* popMenu;
@property (nonatomic, strong) UIView *markView;
- (void)addSubViews;
- (void)removeSubViews;
@end
