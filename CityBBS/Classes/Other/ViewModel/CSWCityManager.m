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
{
    dispatch_group_t _inGroup;

}

+ (instancetype)manager {

    static CSWCityManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CSWCityManager alloc] init];
        manager.cityDict = [NSMutableDictionary dictionary];
        manager.citys = [NSMutableArray array];
        
//        manager.cityDict[CSW_RECOMMEND_CITY] = [NSArray new];
//        manager.cityDict[CSW_CURRENT_CITY] = [NSArray new];

        
    });
    
    return manager;

}

//
- (instancetype)init {

    if (self = [super init]) {
        
        _inGroup = dispatch_group_create();
        
    }
    
    return self;
    
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
- (void)getCityDetailBy:(CSWCity *)city success:(void(^)())success failure:(void(^)())failure {

//    获取菜单列表: 610087
//    获取banner列表: 610107
//    获取11个子系统列表：610097
    
    __block  NSMutableArray *bannerRoom = nil;
    __block  NSMutableArray *funcRoom = nil;
    __block  NSArray <CSWTabBarModel *>*tabBarRoom = nil;
    
    __block NSInteger succesCount = 0;
    
    //banner
    dispatch_group_enter(_inGroup);
    TLNetworking *tabBarHttp = [TLNetworking new];
    tabBarHttp.code = @"610107";
    tabBarHttp.parameters[@"companyCode"] = city.code;
    [tabBarHttp postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_inGroup);
        succesCount ++;
        bannerRoom = [CSWBannerModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);
        if (failure) {
            failure();
        }
        
    }];


    //获取11个子系统
    dispatch_group_enter(_inGroup);
    TLNetworking *systemHttp = [TLNetworking new];
    systemHttp.code = @"610097";
    systemHttp.parameters[@"companyCode"] = city.code;
    [systemHttp postWithSuccess:^(id responseObject) {
        
        funcRoom = [CSWFuncModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        succesCount ++;
        
        dispatch_group_leave(_inGroup);
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);
        
        if (failure) {
            failure();
        }

    }];
    
    
    //获取底部菜单
    dispatch_group_enter(_inGroup);
    TLNetworking *http = [TLNetworking new];
    http.code = @"610087";
    http.parameters[@"companyCode"] = city.code;
    [http postWithSuccess:^(id responseObject) {
        
        tabBarRoom = [CSWTabBarModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        succesCount ++;

        dispatch_group_leave(_inGroup);
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);

        if (failure) {
            failure();
        }
        
    }];
    
   dispatch_group_notify(_inGroup, dispatch_get_main_queue(), ^{
       
       if (succesCount == 3) {
       
           self.bannerRoom = bannerRoom;
           self.func3Room = [funcRoom subarrayWithRange:NSMakeRange(0, 3)];
           self.func8Room = [funcRoom subarrayWithRange:NSMakeRange(3, 8)];
           
           self.tabBarRoom = [tabBarRoom subarrayWithRange:NSMakeRange(0, 4)];
           self.xiaoMiModel = tabBarRoom[4];
           
           if (success) {
               success();
           }
           
       }
       
   });

}

#pragma mark- 统一处理，跳转
+ (void)jumpWithUrl:(NSString *)url navCtrl:(UINavigationController *)nacCtrl parameters:(id)parameters {
    
    UIViewController *vc = [[UIViewController alloc] init];
    [nacCtrl pushViewController:vc animated:YES];
    if ([parameters isKindOfClass:[NSString class]]) {
        
    } else {
    
    }

}

@end