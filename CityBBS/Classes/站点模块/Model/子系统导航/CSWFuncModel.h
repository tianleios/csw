//
//  CSWFuncModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWFuncModel : TLBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *url;

//--//
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSNumber *belong;
@property (nonatomic, copy) NSString *companyCode;

//--//

@end
