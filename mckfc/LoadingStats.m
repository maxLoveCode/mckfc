//
//  LoadingStats.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/29.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoadingStats.h"

@implementation LoadingStats

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"supplier":@"vendorid",
             @"field":@"placeNo",
             @"departuretime":@"departuretime",
             @"extraInfo":@"extraInfo",
             @"weight":@"weight"};
}

-(instancetype)init
{
    self = [super init];
    
    if (!self.departuretime) {
        self.departuretime = [NSDate date];
    }
    
    return self;
}

-(void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"weight"]) {
        self.weight = 0;
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"stats: %@", [MTLJSONAdapter JSONDictionaryFromModel:self error:nil]];
}
@end
