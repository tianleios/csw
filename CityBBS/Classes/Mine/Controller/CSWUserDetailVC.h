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

//@property (nonatomic, assign) CSWUserDetailVCType type;

//用户id 或者 用户昵称,优先使用用户ID，如果id不存在，那就根据昵称加载用户
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;


@end
