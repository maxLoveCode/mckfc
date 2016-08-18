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
    self.accessoryView = self.accessoryImage;
    return self;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
    }
    return _title;
}

-(UIButton *)accessoryImage
{
    if (!_accessoryImage) {
        UIImage* image = [UIImage imageNamed:@"scanSmall"];
        _accessoryImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessoryImage setImage:image forState:UIControlStateNormal];
        [_accessoryImage setFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _accessoryImage;
}


+(CGFloat)cellHeight
{
    return itemHeight;
}

-(void)setContent:(NSDictionary *)content
{
    NSLog(@"%@", content);
    self->_content = content;
    User* user;
    LoadingStats* stats;
    if ([_content objectForKey:@"user"]) {
        user =[_content objectForKey:@"user"];
        self.title.text = user.truckno;
    }
    if ([_content objectForKey:@"stat"]){
        stats = [_content objectForKey:@"stat"];
    }
    _json = [self generateFastPass:stats User:user];
    if (!_json) {
        self.accessoryView = UITableViewCellAccessoryNone;
    }
}

-(NSDictionary*)generateFastPass:(LoadingStats*)stats User:(User*)user
{
    NSDictionary* qrcode = [[NSDictionary alloc] init];
    if ([stats validForStartingTransport]) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        qrcode = @{@"weight":stats.weight,
                   @"serialno":stats.serialno,
                   @"departuretime":[dateFormatter stringFromDate:stats.departuretime],
                   @"city":[NSString stringWithFormat:@"%@",stats.city.name],
                   @"landId":[NSString stringWithFormat:@"%lu",(unsigned long)stats.field.fieldID],
                   @"land":stats.field.name,
                   @"providerId":[NSString stringWithFormat:@"%lu",(unsigned long)stats.supplier.vendorID],
                   @"provider":stats.supplier.name,
                   @"driver":user.driver,
                   @"mobile":user.mobile,
                   @"truckno":user.truckno,
                   @"packageTypeId":stats.package.packageid,
                   @"packageType":stats.package.name
                   };
        NSLog(@"qrcode %@", qrcode);
        return qrcode;
    }
    return nil;
}

@end
