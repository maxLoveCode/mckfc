//
//  CarDriverInfoCell.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CarDriverInfoCell.h"

@interface CarDriverInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;


@end

@implementation CarDriverInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(TruckListModel *)model{
    _nameLab.text = model.driver;
    _carNumLab.text = model.truckno;
    _phoneLab.text = model.mobile;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
