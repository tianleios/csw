//
//  CSWPlateDetailModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/5/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "CSWSmallPlateModel.h"

@class CSWSmallPlateModel;

@interface CSWPlateDetailModel : TLBaseModel

@property (nonatomic, strong) NSNumber *allPostCount;
@property (nonatomic, strong) NSNumber *essence; //精华数目
@property (nonatomic, strong) NSNumber *top; //置顶数量数目
@property (nonatomic, strong) CSWSmallPlateModel *splate;
@property (nonatomic, strong) NSNumber *todayPostCount;



@end
