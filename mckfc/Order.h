//
//  Order.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/27.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Order : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* orderID;

@end
