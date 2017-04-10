//
//  CSWLoadRootVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWLoadRootVC.h"
#import <MapKit/MapKit.h>
#import "TLTabBarController.h"

@interface CSWLoadRootVC ()<CLLocationManagerDelegate>

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWLoadRootVC
{
    
    CLLocationManager *_locationManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //定位
    self.isFirst = YES;
    
    
    //
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"lanuch"];
    
    //根据定位加载城市
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

#pragma locaiton-delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (!self.isFirst) {
        return;
    }
    self.isFirst = NO;
    //停止定位
    [manager stopUpdatingLocation];
    
    
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    CLLocation *location = manager.location;
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        if (error) {
            return ;
        }
        
        [TLProgressHUD showWithStatus:@"努力加载站点中"];
        TLNetworking *http = [TLNetworking new];
        http.code = @"806012";
        http.parameters[@"province"] = placemark.administrativeArea ? : @"";
        http.parameters[@"city"] = placemark.locality ? : placemark.administrativeArea;
        http.parameters[@"area"] = placemark.subLocality;
        [http postWithSuccess:^(id responseObject) {
            
            //当前站点
            [CSWCityManager manager].currentCity = [CSWCity tl_objectWithDictionary:responseObject[@"data"]];
            
            //获取站点详情
            [[CSWCityManager manager] getCityDetailBy:[CSWCityManager manager].currentCity success:^{
                [TLProgressHUD dismiss];

                   [UIApplication sharedApplication].keyWindow.rootViewController = [[TLTabBarController alloc] init];
                
            } failure:^{
                [TLProgressHUD dismiss];
                [TLProgressHUD showErrorWithStatus:@"获取站点失败"];

                
            }];

         
            
        } failure:^(NSError *error) {
            
            [TLProgressHUD dismiss];
            [TLProgressHUD showErrorWithStatus:@"获取站点失败"];

        }];
        
    }];
    
}


@end
