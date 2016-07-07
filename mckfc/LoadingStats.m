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
             @"startTime":@"startTime",
             @"extraInfo":@"extraInfo"};
}

-(instancetype)init
{
    self = [super init];
    
    [self defaultValues];
    
    return self;
}

-(void)defaultValues
{
    self.supplier = @"";
    self.placeNo = @"";
    self.startTime = nil;
    self.extraInfo = @"";
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"stats: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}
@end
