//
//  CSWCityManager.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSWCity.h"
#import "CSWTabBarModel.h"
#import "CSWFuncModel.h"
#import "CSWBannerModel.h"

@interface CSWCityManager : NSObject

+ (instancetype)manager;

/**
 当前城市
 */
@property (nonatomic, strong) CSWCity *currentCity;

// "A" : [city1,city2,city3]
@property (nonatomic, strong) NSMutableDictionary <NSString * ,NSArray<CSWCity *>*>* cityDict;

//城市列表
@property (nonatomic, strong) NSMutableArray <CSWCity *>*citys;

//导航数据
@property (nonatomic, copy) NSArray <CSWBannerModel *>*bannerRoom; //banner
@property (nonatomic, copy) NSArray <CSWFuncModel *>*func3Room; //3个功能
@property (nonatomic, copy) NSArray <CSWFuncModel *>*func8Room; //8个功能
@property (nonatomic, copy) NSArray <CSWTabBarModel *>*tabBarRoom; //4个tabbar
@property (nonatomic, strong) CSWTabBarModel *xiaoMiModel; //中间小蜜

- (void)getCityListSuccess:(void(^)())success failure:(void(^)())failure;

/**
 获取城市详情
 */
- (void)getCityDetailBy:(CSWCity *)city success:(void(^)())success failure:(void(^)())failure;

+ (void)jumpWithUrl:(NSString *)url navCtrl:(UINavigationController *)nacCtrl parameters:(id)parameters signin:(void(^)())signinBlock;

@end


FOUNDATION_EXTERN NSString * const kCityChangeNotification;
