//
//  MCStarView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCStarView;

@interface MCStarView : UIView

@property (nonatomic, strong) NSMutableArray* starViews;

-(instancetype)initWithCount:(NSInteger)count;
-(void)setStarValue:(NSInteger)stars;

-(CGSize)sizeOfView;

@end
