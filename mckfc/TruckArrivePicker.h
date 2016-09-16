//
//  TruckArrivePicker.h
//  mckfc
//
//  Created by 华印mac-001 on 16/9/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckArrivePicker : UIView

-(void)show;
@property (nonatomic, strong) void(^selectBlock)(NSDate*result);

@end
