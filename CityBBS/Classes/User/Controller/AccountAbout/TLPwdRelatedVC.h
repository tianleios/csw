//
//  ZHPwdRelatedVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLAccountSetBaseVC.h"


typedef  NS_ENUM(NSInteger,TLPwdType) {
    
    TLPwdTypeForget = 0, //忘记密码
    TLPwdTypeReset, //重设密码
    TLPwdTypeTradeReset //交易密码
};

@interface TLPwdRelatedVC : TLAccountSetBaseVC

- (instancetype)initWith:(TLPwdType)type;

@property (nonatomic,copy)  void(^success)();


@end
