//
//  Vendor.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Vendor : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSUInteger vendorID; //vendor id
@property (nonatomic, copy) NSString *name; //vendor name

@end
