//
//  MapViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@protocol mapViewDelegate <NSObject>
@optional
-(void)mapView:(MapViewController*)mapView
                            LocationOnLatitude:(double)latitude
                                    Longtitude:(double)longtitude
                                       address:(NSString*)address
                                      distance:(double)distance
                                    expecttime:(long)expecttime;
-(void)mapViewhasLocated:(MapViewController*)mapView;

@end

@interface MapViewController : UIViewController

@property (nonatomic, weak) id<mapViewDelegate> delegate;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,assign) float locationTime;

-(instancetype)initWithTerminateLong:(double)longtitude Lat:(double)latitude;

@end
