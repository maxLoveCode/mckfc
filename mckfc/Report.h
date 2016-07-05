//
//  Report.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Report : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* weight;
@property (nonatomic, copy) NSString* quality;

+(NSInteger)numberOfProperties;

@end
