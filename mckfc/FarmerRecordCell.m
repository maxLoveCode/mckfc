//
//  FarmerRecordCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/9.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerRecordCell.h"
#define itemHeight 44

@interface FarmerRecordCell()

@end

@implementation FarmerRecordCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"famerRecord"];
    [self.contentView addSubview:self.title];
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width, itemHeight));
        make.left.equalTo(self.contentView.left).with.offset(k_Margin);
    }];
    return self;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
    }
    return _title;
}

+(CGFloat)cellHeight
{
    return itemHeight;
}

-(void)setContent:(NSDictionary *)content
{
    self->_content = content;
    if ([_content objectForKey:@"user"]) {
        User* user =[_content objectForKey:@"user"];
        self.title.text = user.truckno;
    }
}
@end
