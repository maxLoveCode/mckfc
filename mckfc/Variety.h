//
//  Variety.h
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/20.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Variety : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString* varietyid;

@end
