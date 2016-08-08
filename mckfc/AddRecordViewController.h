//
//  AddRecordViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/5.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecordTable.h"
@class AddRecordTable;

@protocol AddRecordTableDelegate <NSObject>

-(void)addRecordView:(AddRecordTable*)viewdidBeginEditing;
-(void)endEditing:(AddRecordTable*)viewEndEditing;

@end

@interface AddRecordViewController : UIViewController

@property (nonatomic, strong) AddRecordTable* tableView;

@property (nonatomic, weak) id<AddRecordTableDelegate> delegate;

@end
