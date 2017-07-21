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
#import "Package.h"
#import "Factory.h"
#import "Storage.h"
#import "Variety.h"
@interface LoadingStats : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) Field *field; //地块编号
@property (nonatomic, strong) Vendor *supplier; //供应商名称
@property (nonatomic, strong) City *city;
@property (nonatomic, strong) Package *package;
@property (nonatomic, strong) Factory *factory;
@property (nonatomic,strong) Storage *storage;//存储期
@property (nonatomic,strong) Variety *variety;//薯品种
@property (nonatomic, copy) NSNumber *weight;
@property (nonatomic, copy) NSDate *departuretime; //开始日期
@property (nonatomic,copy) NSDate *planarrivetime;
@property (nonatomic, copy) NSString *extraInfo; //额外信息
@property (nonatomic, copy) NSString *serialno;
-(instancetype)init;
-(BOOL)validForStartingTransport;
@end
