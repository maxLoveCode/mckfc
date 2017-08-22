//
//  Factory.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/19.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Factory : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name; 
@property (nonatomic, copy) NSString* factoryid;
@property (nonatomic, strong) NSNumber *pointx;
@property (nonatomic, strong) NSNumber *pointy;

@end
