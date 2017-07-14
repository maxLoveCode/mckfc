//
//  CreatQRCodeView.h
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/11.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol didClickUploadImgDelegate <NSObject>
@optional
- (void)didClickUpdateImg:(NSString*)fielduserid;

@end

@interface CreatQRCodeView : UITableView
@property (nonatomic,copy) NSString *numberCode;
@property (nonatomic,weak) id<didClickUploadImgDelegate> uploadImgDelegate;
@end
