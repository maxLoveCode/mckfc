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
             @"extraInfo":@"extraInfo",
             @"inspections":
                 @[@"impurity",@"oil",@"chemical",@"smell",@"tarpaulin"]};
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
    
    self.inspections = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                        @"impurity":@"0",
                                                                        @"oil":@"0",
                                                                        @"chemical":@"0",
                                                                        @"smell":@"0",
                                                                        @"tarpaulin":@"0"}];
    self.startTime = nil;
    self.extraInfo = @"";
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"stats: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}
@end
