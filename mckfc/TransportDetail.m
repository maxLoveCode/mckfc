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
             @"factoryphone":@"factoryphone",
             @"autoLocationTime":@"autolocationtime"};
}

-(instancetype)initWithID:(NSInteger)transportID
{
    self = [super init];
    self.transportID = transportID;
    
    return self;
}

-(void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"transportID"]) {
        self.transportID = 0;
    }
    else
    {
        [super setNilValueForKey:key];
    }
}

@end
