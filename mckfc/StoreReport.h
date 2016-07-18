//
//  StoreReport.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Store.h"

@interface StoreReport : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSString* transportid;
@property (nonatomic, assign) Store* store;

@property (nonatomic, assign) BOOL material;
@property (nonatomic, assign) BOOL petrol;
@property (nonatomic, assign) BOOL chemical;
@property (nonatomic, assign) BOOL smell;

-(instancetype)initWithTransportID:(NSString*)transportid;


@end
