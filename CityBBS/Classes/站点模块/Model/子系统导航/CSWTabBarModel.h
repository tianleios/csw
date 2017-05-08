//
//  CSWTabBarModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWTabBarModel : TLBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;

//未选中的图片
@property (nonatomic, copy) NSString *selectedImageUrl;
//选中的图片
@property (nonatomic, copy) NSString *unSelectedImageUrl;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSNumber *belong;
@property (nonatomic, strong) NSNumber *orderNo;

@property (nonatomic, copy) NSString *companyCode;

@end
