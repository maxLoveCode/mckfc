//
//  TransportDetail.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TransportDetail.h"

@implementation TransportDetail

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"departuretime":@"departuretime",
             @"destination":@"destination",
             @"planarrivetime":@"planarrivetime",
             @"planentertime":@"planentertime",
             @"pointx":@"pointx",
             @"pointy":@"pointy",
             @"transportID":@"id",
             @"factoryphone":@"factoryphone"};
}

-(instancetype)initWithID:(NSInteger)transportID
{
    self = [super init];
    self.transportID = transportID;
    
    return self;
}

@end
