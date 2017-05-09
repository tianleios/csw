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

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;


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
    [TLProgressHUD showWithStatus:@"努力加载站点中"];
    
//    if(![TLUser user].userId) {
//    
//        CSWCity *city = [CSWCity new];
//        city.code = [TLUser user].companyCode;
//        [[CSWCityManager manager] getCityDetailBy:city success:^{
//            
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[TLTabBarController alloc] init];
//            
//        } failure:^{
//            
//            [TLProgressHUD showErrorWithStatus:@"获取站点失败"];
//
//        }];
//        
//    } else {
    
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        
//    }
 
}

#pragma locaiton-delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    //定位失败加载默认站点
    [TLProgressHUD dismiss];
    [TLAlert alertWithError:@"定位失败，将加载默认站点"];
    
    [self goWithProvience:@"未知" city:@"未知" area:@"未知"];
    
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
            
            [TLProgressHUD dismiss];
            [TLAlert alertWithError:@"获取站点失败"];
            return ;
        }
        
        
        [self goWithProvience:placemark.administrativeArea ? : @"" city:placemark.locality ? : placemark.administrativeArea area:placemark.subLocality];
 
    }];
    
}


//根据省市区加载站点
- (void)goWithProvience:(NSString *)province city:(NSString *)city area:(NSString *)area {

    //
    self.currentProvince= province;
    self.currentCity = city;
    self.currentArea = area;
    
    //[TLProgressHUD showWithStatus:@"努力加载站点中"];
    TLNetworking *http = [TLNetworking new];
    http.code = @"806012";
    http.parameters[@"province"] = province;
    
    http.parameters[@"city"] = city;
    //        [city substringWithRange:NSMakeRange(0, city.length - 1)];
    http.parameters[@"area"] = area;
    
    
    [http postWithSuccess:^(id responseObject) {
        
        //移除可能出现的站位
        [self.tl_placeholderView removeFromSuperview];
        
        //当前站点
        [CSWCityManager manager].currentCity = [CSWCity tl_objectWithDictionary:responseObject[@"data"]];
        
        //获取站点详情
        CSWCity *city = [CSWCityManager manager].currentCity;
        
        [[CSWCityManager manager] getCityDetailBy:city success:^{
            
            [TLProgressHUD dismiss];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TLTabBarController alloc] init];
            
        } failure:^{
            
            [TLProgressHUD dismiss];
            [TLAlert alertWithError:@"获取站点失败"];
            
            
            //应该出现重新加载,按钮
            [self tl_placholderViewWithTitle:@"获取站点失败" opTitle:@"重新获取"];
            [self.view addSubview:self.tl_placeholderView];
            
        }];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        [TLAlert alertWithError:@"获取站点失败"];
        
        
        //应该出现重新加载,按钮
        [self tl_placholderViewWithTitle:@"获取站点失败" opTitle:@"重新获取"];
        [self.view addSubview:self.tl_placeholderView];
        
    }];

}

- (void)tl_placeholderOperation {


    [self goWithProvience:self.currentProvince city:self.currentProvince area:self.currentArea];

}

@end
