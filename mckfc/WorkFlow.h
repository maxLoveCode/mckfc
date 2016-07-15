//
//  WorkFlow.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WorkFlow : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* type;

@property (nonatomic, assign) BOOL auth;
@property (nonatomic, assign) BOOL ischecked;

@end
