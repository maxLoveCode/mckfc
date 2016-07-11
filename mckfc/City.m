//
//  City.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "City.h"

@implementation City

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    self.name = name;
    return self;
}

-(NSString *)description
{
    return self.name;
}

@end
