//
//  DriverDetailEditorCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DriverDetailCellStyle) {
    DriverDetailCellStylePlain,
    DriverDetailCellStyleAvatar,
    DriverDetailCellStyleCarNumber
};

@interface DriverDetailEditorCell : UITableViewCell

-(instancetype)initWithStyle:(DriverDetailCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, assign) DriverDetailCellStyle style;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* avatar;
@property (nonatomic, strong) UITextField* detailLabel;

+(CGFloat)heightForCell;

@end
