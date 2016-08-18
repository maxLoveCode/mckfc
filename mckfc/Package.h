//
//  Package.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Package : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name; //city name
@property (nonatomic, copy) NSString* packageid;


@end
