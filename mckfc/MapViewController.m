//
//  MapViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface MapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}

@end

@implementation MapViewController

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    //配置用户Key
    [AMapServices sharedServices].apiKey = MapKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

@end
