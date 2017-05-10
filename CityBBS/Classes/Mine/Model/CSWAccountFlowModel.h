//
//  CSWAccountFlowModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/5/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWAccountFlowModel : TLBaseModel

@property (nonatomic, copy) NSString *bizNote;
@property (nonatomic, strong) NSNumber *transAmount;
@property (nonatomic, copy) NSString *createDatetime;



//accountNumber = A2017050812285008914;
//bizNote = "\U53d1\U5e03\U8bc4\U8bba\Uff0c\U9001\U8d4f\U91d1";
//bizType = CSW02;
//channelType = 0;
//code = AJ2017050814461022429;
//createDatetime = "May 8, 2017 2:46:10 PM";
//currency = JF;
//postAmount = 7000;
//preAmount = 6000;
//realName = 13868074590;
//status = 1;
//systemCode = "CD-CCSW000008";
//transAmount = 1000;
//userId = U2017050812284990648;
//workDate = 20170508;


@end
