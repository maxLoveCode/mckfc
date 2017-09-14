//
//  CustomAnnotationView.h
//  mckfc
//
//  Created by zc on 2017/9/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MAPinAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end
