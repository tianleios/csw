//
//  TLChangeCityVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "CSWCity.h"

@interface TLChangeCityVC : TLBaseVC

@property (nonatomic, copy) void(^changeCity)(CSWCity *city);

@end
