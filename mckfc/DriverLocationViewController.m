//
//  DriverLocationViewController.m
//  mckfc
//
//  Created by zc on 2017/9/11.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverLocationViewController.h"
#import "ServerManager.h"
#import "TransportDetail.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
@interface DriverLocationViewController ()<AMapSearchDelegate,MAMapViewDelegate>{
    
}
@property (nonatomic,strong) AMapPath* path;
@property (nonatomic, strong) AMapSearchAPI *search;;
@property (nonatomic, strong) ServerManager *server;
@property (nonatomic, strong) TransportDetail *detail;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;
@property (nonatomic, assign) double endPointx;
@property (nonatomic, assign) double endPointy;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSString *startAddress;
@end

@implementation DriverLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"司机位置信息";
    [AMapServices sharedServices].apiKey = MapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [_mapView setZoomLevel:15];
    _mapView.showsUserLocation = NO;
    [_mapView setUserTrackingMode: MAUserTrackingModeNone animated:NO];
    _mapView.pausesLocationUpdatesAutomatically = YES;
    _mapView.delegate = self;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.pointy doubleValue] , [self.pointx doubleValue]);
    _mapView.centerCoordinate = location;
    [self initMapSearch];
     [self initAnnotations];
     [self requestDetails];
    [self.view addSubview:_mapView];
     [self setReverseGeocode];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setReverseGeocode{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *geoLocation = [[CLLocation alloc] initWithLatitude:[self.pointy doubleValue] longitude:[self.pointx doubleValue]];
    [geocoder reverseGeocodeLocation:geoLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        NSDictionary *dic = place.addressDictionary;
        self.startAddress = [NSString stringWithFormat:@"%@%@%@",dic[@"City"],dic[@"SubLocality" ],dic[@"Name"]];
        if (_path) {
            NSTimeInterval interval = (double)_path.duration;
            NSDate* estimate = [NSDate dateWithTimeIntervalSinceNow:interval];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString* string = [dateFormatter stringFromDate:estimate];
            
            self.pointAnnotation.title = [NSString stringWithFormat:@"预计在 %@ 到达",string];
            
            self.pointAnnotation.subtitle = [NSString stringWithFormat:@"%@\n距离目的地还有%.2lf公里",self.startAddress,(float)_path.distance/1000];
            [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
        }
        
    }];
}

- (ServerManager *)server{
    if (!_server) {
        _server = [ServerManager sharedInstance];
    }
    return _server;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   // self.search = nil;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
    //[self.mapView selectAnnotation:self.pointAnnotation animated:YES];
   
}

- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[] = {
        {[self.pointy doubleValue],[self.pointx doubleValue]}
    };
        self.pointAnnotation  = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = coordinates[0];
        self.pointAnnotation.title      = @"";
        [self.annotations addObject:self.pointAnnotation];
}


- (void)initMapSearch{
    if (!self.search) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
   
}

- (void)startPlanRoutes:(double)endPointx endPointy:(double)endPointy{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:[self.pointy doubleValue]
                                           longitude:[self.pointx doubleValue]];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:endPointy
                                            longitude:endPointx];
    [self.search AMapDrivingRouteSearch:navi];
}

//大头针样式
#pragma mark - Map Delegate


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"restaurant"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}


/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    _path = [response.route.paths objectAtIndex:0];
    //通过AMapNavigationSearchResponse对象处理搜索结果
  //  [self didStartRegeoSearch];
    
    NSTimeInterval interval = (double)_path.duration;
    NSDate* estimate = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string = [dateFormatter stringFromDate:estimate];

    self.pointAnnotation.title = [NSString stringWithFormat:@"预计在 %@ 到达",string];
    
    if (_path.distance == 0) {
         self.pointAnnotation.subtitle =@"正在查询距离目的地距离...";
    }
    else
    {
        if (self.startAddress) {
            self.pointAnnotation.subtitle = [NSString stringWithFormat:@"%@\n距离目的地还有%.2lf公里",self.startAddress,(float)_path.distance/1000];
             [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
        }else{
             self.pointAnnotation.subtitle = [NSString stringWithFormat:@"距离目的地还有%.2lf公里",(float)_path.distance/1000];
        }
        
    }
    



}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"=========%@",error);
}

#pragma mark --请求数据
-(void)requestDetails
{
    NSDictionary* params;
    params = @{@"token":self.server.accessToken,
               @"id":self.transportID};
    [_server GET:@"getTransportDetail" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        NSLog(@"data: %@", data);
        NSError* error;
        self.detail = [MTLJSONAdapter modelOfClass:[TransportDetail class] fromJSONDictionary:data error:&error];
        self.endPointx = [self.detail.pointx doubleValue];
        self.endPointy = [self.detail.pointy doubleValue];
        [self startPlanRoutes:self.endPointx endPointy:self.endPointy];
        if (error) {
            NSLog(@"error %@", error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



@end
