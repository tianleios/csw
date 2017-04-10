//
//  CSWCity.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWCity : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL location;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *desc;

@end
