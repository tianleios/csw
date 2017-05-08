//
//  CSWUserDetailVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef  NS_ENUM(NSInteger,CSWUserDetailVCType){

    CSWUserDetailVCTypeMine = 0,
    CSWUserDetailVCTypeOther
};

@interface CSWUserDetailVC : TLBaseVC

@property (nonatomic, assign) CSWUserDetailVCType type;
@property (nonatomic, copy) NSString *userId;


@end
