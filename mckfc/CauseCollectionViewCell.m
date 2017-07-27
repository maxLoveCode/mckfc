//
//  CauseCollectionViewCell.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/24.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CauseCollectionViewCell.h"

@interface CauseCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end

@implementation CauseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _clickBtn.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setTitle:(NSString *)title{
    [_clickBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setClickBool:(BOOL)clickBool{
    _clickBool = clickBool;
    if (clickBool == YES) {
        [_clickBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else{
         [_clickBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
}

@end
