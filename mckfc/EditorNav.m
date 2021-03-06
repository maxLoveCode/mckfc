//
//  EditorNav.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "EditorNav.h"
#import "DriverDetailEditorController.h"

@interface EditorNav()<UINavigationControllerDelegate>

@property (nonatomic, strong) DriverDetailEditorController* EditorVC;

@end

@implementation EditorNav

-(instancetype)init
{
    _EditorVC = [[DriverDetailEditorController alloc] init];
    if (self = [super initWithRootViewController: self.EditorVC]) {
        self.delegate = self;
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = COLOR_WithHex(0xf3f3f3);
        [self.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:COLOR_WithHex(0x878787)}];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


@end
