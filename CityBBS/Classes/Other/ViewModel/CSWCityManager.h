//
//  CSWCityManager.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSWCity.h"

@interface CSWCityManager : NSObject

+ (instancetype)manager;

/**
 当前城市
 */
@property (nonatomic, strong) CSWCity *currentCity;

// "A" : [city,city]
@property (nonatomic, strong) NSMutableDictionary <NSString * ,NSArray<CSWCity *>*>* cityDict;

//城市列表
@property (nonatomic, strong) NSMutableArray <CSWCity *>*citys;

- (void)getCityListSuccess:(void(^)())success failure:(void(^)())failure;
+ (void)getCityDetailBy:(CSWCity *)city success:(void(^)())success failure:(void(^)())failure;

@end
