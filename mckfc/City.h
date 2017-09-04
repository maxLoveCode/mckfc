//
//  City.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface City : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name; //city name
@property (nonatomic, copy) NSString* areaid;
@property (nonatomic, strong) NSNumber *time;


-(instancetype)initWithName:(NSString*)name;

@end
