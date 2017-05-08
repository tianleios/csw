//
//  CSWNavModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWNavModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *belong;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *remark;

@end
