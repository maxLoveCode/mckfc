//
//  Message.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Message.h"
#import "MsgTableViewCell.h"

#define cellEstimateHeight 130.0f
#define titleLabelHeight 32.0f
#define timeLabelHeight 22.0f

@implementation Message

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"title":@"title",
             @"msgid":@"id",
             @"readflag":@"readflag",
             @"content":@"content",
             @"createDate":@"createtime",
             };
}

+(NSValueTransformer *)createDateJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if([value isKindOfClass:[NSString class]])
        {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            return [formatter dateFromString:value];
        }
        else
            return value;
    }];
}

-(CGFloat)contentHeight
{
    CGFloat textHeight = [MsgTableViewCell findHeightForText:self.content havingWidth:kScreen_Width-2*k_Margin andFont:[UIFont systemFontOfSize:16]].height;
    CGFloat originHeight = cellEstimateHeight-titleLabelHeight-timeLabelHeight-10;
    if (textHeight > originHeight) {
        return cellEstimateHeight + (textHeight - originHeight);
    }
    else
        return cellEstimateHeight;
}


@end
