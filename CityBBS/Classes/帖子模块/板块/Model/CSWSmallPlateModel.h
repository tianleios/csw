//
//  CSWSmallPlateModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWSmallPlateModel : TLBaseModel

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *bplateCode;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *moderator; //版主
@property (nonatomic, strong) NSNumber *status;


//
//bplateCode = BMK201704911042439602;
//code = SPK201704910113264810;
//companyCode = GS2017033013320557598;
//moderator = U2017033121141854178;
//name = "\U6545\U4e8b\U4f1a";
//orderNo = 7;
//pic = "xiwu_1491023753457.jpg";
//remark = "";
//status = 1;
//updateDatetime = "Apr 1, 2017 1:13:26 PM";
//updater = "\U4f59\U676d";

@end
