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




//address = fadg;
//area = "\U4e1c\U57ce\U533a";
//city = "\U5317\U4eac";
//code = GS201703231525547527;
//
//domain = "";
//email = "11@qq.com";
//isDefault = 0;
//isHot = 0;
//location = 1;
//logo = "";
//
//mobile = "0371-68787027";
//name = "\U5317\U4eac\U516c\U4ea4";
//
//province = "\U5317\U4eac";
//qrCode = "";
//remark = "";
//systemCode = "CD-CCSW000008";
//type = 1;
//updateDatetime = "Mar 23, 2017 3:25:54 PM";
//updater = admin;
//userId = U2017032218022084939;

@end
