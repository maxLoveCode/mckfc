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
             @"supplier":@"supplier",
             @"placeNo":@"placeNo",
             @"departuretime":@"departuretime",
             @"extraInfo":@"extraInfo",
             @"weight":@"weight"};
}

-(instancetype)init
{
    NSLog(@"23123");
    self = [super init];
    [self defaultValues];
    return self;
}

-(void)defaultValues
{
    self.supplier = @"请选择供应商";
    self.placeNo = @"请选择地区";
    self.departuretime = nil;
    self.extraInfo = @"";
    
    self.weight = [NSNumber numberWithInteger:0];
}

-(void)setNilValueForKey:(NSString *)key
{
    NSLog(@"test");
    if ([key isEqualToString:@"supplier"]) {
        self.supplier = @"请选择供应商";
    }else if([key isEqualToString:@"placeNo"]){
        self.placeNo = @"请选择地区";
    }else if([key isEqualToString:@"startTime"]){
        
    }else if([key isEqualToString:@"weight"]){
        self.weight = 0;
    }else
    {
        [super setNilValueForKey:key];
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"stats: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}
@end
