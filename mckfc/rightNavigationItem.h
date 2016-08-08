//
//  rightNavigationItem.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class rightNavigationItem;

typedef NS_ENUM(NSUInteger, rightNavigationItemStyle) {
    navItemStyleHomepage, //homepage
    navItemStyleTransport, //default
};

@protocol menuDelegate <NSObject>

-(void)MenuView:(rightNavigationItem*)Menu selectIndexPath:(NSIndexPath*)indexPath;

@end

@interface rightNavigationItem : UIBarButtonItem <UITableViewDataSource, UITableViewDelegate>

-(instancetype)initCutomItem;

@property (nonatomic, strong) UITableView* popMenu;
@property (nonatomic, strong) UIView* mask;
@property (nonatomic, weak) id<menuDelegate> delegate;
@property (nonatomic, assign) rightNavigationItemStyle ItemStyle;

-(void)dismiss;

@end
