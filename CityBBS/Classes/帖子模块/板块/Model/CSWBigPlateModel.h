//
//  CSWBigPlateModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWBigPlateModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *name;

//0待上架 -- 1已上架
@property (nonatomic, strong) NSNumber *status;


@end
