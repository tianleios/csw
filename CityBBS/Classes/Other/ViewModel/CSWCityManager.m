//
//  CSWCityManager.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCityManager.h"

#define CSW_RECOMMEND_CITY @"推荐"
#define CSW_CURRENT_CITY @"当前"

@implementation CSWCityManager

+ (instancetype)manager {

    static CSWCityManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CSWCityManager alloc] init];
        manager.cityDict = [NSMutableDictionary dictionary];
        manager.citys = [NSMutableArray array];
        
        manager.cityDict[CSW_RECOMMEND_CITY] = [NSArray new];
        manager.cityDict[CSW_CURRENT_CITY] = [NSArray new];

        
    });
    
    return manager;

}

//- (NSArray<CSWCity *> *)citys {
//
//    NSArray *allKeys = self.cityDict.allKeys;
//    if (allKeys.count <= 0) {
//        return nil;
//    }
//    [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
//
//    return nil;
//}

#pragma mark- 获取城市列表
- (void)getCityListSuccess:(void(^)())success failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"806017";
    [http postWithSuccess:^(id responseObject) {
        
        //1.清楚数组
        [self.citys removeAllObjects];
        //转换对象
        NSDictionary *dict = responseObject[@"data"];
        //找出推荐
        NSMutableArray <CSWCity *> *hotCitys = [NSMutableArray array];
        
        [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //取出数组
            NSString *initilStr = dict.allKeys[idx];
            NSArray *citys =  dict[initilStr];
            
            NSArray <CSWCity *>*cityModels = [CSWCity tl_objectArrayWithDictionaryArray:citys];
            [self.citys addObjectsFromArray:cityModels];
            
            //找出推荐热门程序
            [cityModels enumerateObjectsUsingBlock:^(CSWCity * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
                if (city.isHot) {
                    
                    [hotCitys addObject:city];
                }
                
            }];
            
            self.cityDict[initilStr] = cityModels;

            
        }];
        
        //组装推荐
//        self.cityDict[CSW_CURRENT_CITY] = [NSArray new];
//        self.cityDict[CSW_RECOMMEND_CITY] = hotCitys;
//        NSMutableDictionary
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];

}

#pragma mark- 根据站点查询站点详情
+ (void)getCityDetailBy:(CSWCity *)city success:(void(^)())success failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610086";
    http.parameters[@"companyCode"] = city.code;

    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
        
    }];

}

@end
