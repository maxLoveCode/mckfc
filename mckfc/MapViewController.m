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
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    MAMapPoint termination;
    AMapSearchAPI *_search;
}

@property (nonatomic,strong) AMapPath* path;
@property (nonatomic,strong) MAUserLocation* userLocation;
@property (nonatomic,strong) NSMutableArray* polys;

@property (nonatomic, assign) double terminateLongtitude;
@property (nonatomic, assign) double terminateLatitude;

@end

@implementation MapViewController

-(instancetype)initWithTerminateLong:(double)longtitude Lat:(double)latitude
{
    self = [super init];
    self.terminateLongtitude = longtitude;
    self.terminateLatitude = latitude;
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    //配置用户Key
    [AMapServices sharedServices].apiKey = MapKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    //[self terminateHarBin];
    [self.view addSubview:_mapView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _search = nil;
    _userLocation = nil;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        _userLocation = userLocation;
        
        [_mapView selectAnnotation:userLocation animated:YES];
        
        if (!_path &&userLocation) {
            
            _userLocation.title = @"正在计算规划路程...";
            //[self initSearchInstanceWithStartPoint:userLocation.coordinate];
        }
        if (_userLocation)
        {
            if (!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(repeatTimer) userInfo:nil repeats:YES];
                [_timer fire];
            }
        }
    }
}

-(void)terminateHarBin
{
    termination = MAMapPointForCoordinate(CLLocationCoordinate2DMake(44.04, 125.42));
}

-(void)initSearchInstanceWithStartPoint:(CLLocationCoordinate2D)startPoint;
{
    NSLog(@"发起路径搜索请求");
    //初始化检索对象
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:startPoint.latitude longitude:startPoint.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:_terminateLatitude longitude:_terminateLongtitude];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    
    //发起路径搜索
    
    [_search AMapDrivingRouteSearch: request];
}

#pragma mark start searching

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    _path = [response.route.paths objectAtIndex:0];
    //delegate to parent view controller
    [self.delegate mapViewhasLocated:self];
    //通过AMapNavigationSearchResponse对象处理搜索结果
    [self didStartRegeoSearch];
    
    NSTimeInterval interval = (double)_path.duration;
    NSDate* estimate = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string = [dateFormatter stringFromDate:estimate];
    
    
    _userLocation.title = [NSString stringWithFormat:@"预计在 %@ 到达",string];
    if (_path.distance == 0) {
        _userLocation.subtitle =@"正在查询距离目的地距离...";
    }
    else
    {
        _userLocation.subtitle =[NSString stringWithFormat:@"距离目的地还有%.2lf公里", (float)_path.distance/1000];
    }
    if (!_polys) {
        _polys = [[NSMutableArray alloc] init];
        [_path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
            if (step!=nil) {
                MAPolyline* line = [MapViewController polylineForStep:step];
                [_polys addObject:line];
            }
        }];
        [_mapView addOverlays:_polys];
    }
}

-(void)didStartRegeoSearch
{
    //初始化检索对象
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude     longitude:_userLocation.coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        //NSLog(@"ReGeo: %@", result);
        
        [self.delegate mapView:self LocationOnLatitude:_userLocation.coordinate.latitude Longtitude:_userLocation.coordinate.longitude address:response.regeocode.formattedAddress distance:_path.distance expecttime:_path.duration*1000];
    }
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        return polylineView;
    }
    return nil;
}

#pragma mark common ultility
+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString
{
    if (coordinateString.length == 0)
    {
        return nil;
    }
    
    NSUInteger count = 0;
    CLLocationCoordinate2D *coordinates = [self coordinatesForString:coordinateString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    
    free(coordinates), coordinates = NULL;
    
    return polyline;
}

+ (MAPolyline *)polylineForStep:(AMapStep *)step
{
    if (step == nil)
    {
        return nil;
    }
    
    return [self polylineForCoordinateString:step.polyline];
}

#pragma mark timer
-(void)repeatTimer
{
    [self initSearchInstanceWithStartPoint:_userLocation.coordinate];
}


@end
