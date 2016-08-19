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
             @"weight":@"weight",
             @"serialno":@"serialno"};
}

-(instancetype)init
{
    self = [super init];
    
    if (!self.departuretime) {
        self.departuretime = [NSDate date];
        self.weight = [NSNumber numberWithInteger:0];
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

-(BOOL)validForStartingTransport
{
    if (self.weight == 0) {
        return NO;
    }
    if (!self.supplier || self.supplier.vendorID == 0) {
        return NO;
    }
    if (!self.field || self.field.fieldID == 0){
        return NO;
    }
    if (!self.serialno || [self.serialno isEqualToString:@""]) {
        return NO;
    }
    if (!self.departuretime) {
        return NO;
    }
    if (!self.package)
    {
        return NO;
    }
    if (!self.factory)
    {
        return NO;
    }
    NSLog(@"short cut");
    return YES;
}
@end
