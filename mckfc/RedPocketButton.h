//
//  RedPocketButton.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPocketButton : UIButton

@property (nonatomic, strong) UIButton* claim;
@property (nonatomic, strong) UITextView* content;

-(void)attachToView:(UIView*)view;
-(void)setString:(NSString*)string;

@end
