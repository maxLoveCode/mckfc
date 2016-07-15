//
//  LoadingStats.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/29.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Vendor.h"
#import "Field.h"
#import "City.h"

@interface LoadingStats : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) Vendor *supplier; //供应商名称
@property (nonatomic, copy) City *city;
@property (nonatomic, copy) Field *field; //地块编号
@property (nonatomic, copy) NSNumber *weight;
@property (nonatomic, copy) NSDate *departuretime; //开始日期
@property (nonatomic, copy) NSString *extraInfo; //额外信息

-(instancetype)init;

@end
