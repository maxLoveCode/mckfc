//
//  StoreReport.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "StoreReport.h"

@implementation StoreReport

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"transportid":@"transportid",
             @"material":@"material",
             @"petrol":@"petrol",
             @"chemical":@"chemical",
             @"smell":@"smell"};
}

-(instancetype)initWithTransportID:(NSString *)transportid
{
    self = [super init];
    self.transportid = transportid;
    return self;
}

@end
