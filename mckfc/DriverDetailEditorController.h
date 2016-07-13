//
//  DriverDetailEditorController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface DriverDetailEditorController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL registerComplete;

-(void)setUser:(User*)user;

@end
