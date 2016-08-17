//
//  ZBLocationManager.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

//记得在plist文件中添加NSLocationWhenInUseUsageDescription

#import "ZBLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ZBLocationManager ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager * locationManager;

@property(nonatomic,assign)BOOL isUserCanLocation;

@property(nonatomic,copy)LocationSever locationBlock;

@end

@implementation ZBLocationManager {
    NSString * _city;
    NSString * _pro;
    NSString * _area;
}

+(instancetype)shareInstance{
    static ZBLocationManager * manager = nil;
    static dispatch_once_t oneToken;
    
    dispatch_once (&oneToken, ^ {
        manager = [[self  alloc] init];
    });
    return manager;
    
}

-(void)startLocationSeverWithBlock:(LocationSever)block{
    self.locationBlock = block;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请在“设置”－“隐私”－“定位服务”中，找到伙伴经纪人更改" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
        self.locationBlock?self.locationBlock(NO,@"",@"",@""):nil;
    }else
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark --CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    WS(wself);
    [geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count>0) {
            _isUserCanLocation = YES;
            
            CLPlacemark * mark = placemarks.lastObject;
            
            _city = mark.locality;
            
            if (!_city) {
                _pro = mark.administrativeArea;
                _area = mark.administrativeArea;
                _city = mark.subLocality;
            }else{
                _pro = mark.administrativeArea;
                _area = mark.subLocality;
            }
        }
        wself.locationBlock?wself.locationBlock(YES,_pro,_area,_city):nil;
        [manager stopUpdatingHeading];
        [manager stopUpdatingLocation];
    }];
    [manager stopUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    LOG(@"获取定位失败");
}

-(void)stopLocationSever {
    [_locationManager  stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
}

@end
