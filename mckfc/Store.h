//
//  Store.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Store : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSUInteger storeID; //vendor id
@property (nonatomic, copy) NSString *name; //vendor name

@end
