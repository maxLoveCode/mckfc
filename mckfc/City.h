//
//  City.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface City : MTLModel

@property (nonatomic, copy) NSString *name; //city name

-(instancetype)initWithName:(NSString*)name;

@end
