//
//  CSWRelationUserModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/5/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWRelationUserModel : TLBaseModel

//kind = f1;
//level = 2;
//loginName = 13868074590;
//mobile = 13868074590;
//nickname = "\U7530";
//photo = "IOS_1494323059365944_950_1280.jpg";
//status = 0;
//updateDatetime = "May 8, 2017 12:28:49 PM";
//updater = U2017050812284990648;
//userId = U2017050812284990648;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *userId;



@end
