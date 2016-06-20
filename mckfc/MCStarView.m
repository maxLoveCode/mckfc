//
//  MCStarView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MCStarView.h"
#define size 22

@interface MCStarView()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger value;

@end

@implementation MCStarView

-(instancetype)initWithCount:(NSInteger)count
{
    self = [super init];
    self.count = count;
    _starViews = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i=0; i<count; i++)
    {
        UIImageView* star = [[UIImageView alloc] initWithFrame:CGRectMake(i*size, 0, size, size)];
        star.tag = count+1000;
        [_starViews addObject:star];
        [self addSubview:star];
    }
    return self;
}

-(void)setStarValue:(NSInteger)stars
{
    for(NSInteger i=0; i<_count; i++)
    {
        UIImageView* star = [self.starViews objectAtIndex:i];
        if (i< stars) {
            star.image = [UIImage imageNamed:@"star_yellow"];
        }
        else
        {
            star.image = [UIImage imageNamed:@"star"];
        }
    }
}

-(CGSize)sizeOfView
{
    return CGSizeMake(self.count*size, size);
}

@end
