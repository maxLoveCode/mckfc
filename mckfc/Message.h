//
//  Message.h
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Message : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSDate* createDate;

@property (nonatomic, assign) NSNumber* msgid;
@property (nonatomic, assign) BOOL readflag;

-(CGFloat)contentHeight;

@end
