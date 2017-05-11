//
//  TLUser.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUser.h"
#import "TLUserExt.h"
#import "UICKeyChainStore.h"

//#define USER_ID_KEY @"user_id_key_csw"
#define TOKEN_ID_KEY @"token_id_key_csw"
#define USER_INFO_DICT_KEY @"user_info_dict_key_csw"

NSString *const kUserLoginNotification = @"kUserLoginNotification_csw";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification_csw";
NSString *const kUserInfoChange = @"kUserInfoChange_csw";

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
    });
    
    return user;

}

#pragma mark- 调用keyChainStore
//- (void)keyChainStore {
//
//    UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:@"zh_bound_id"];
//    
//    //存值
//    [keyChainStore setString:@"" forKey:@""];
//    //取值
//    [keyChainStore stringForKey:@""];
//
//}

- (void)initUserData {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    self.token = token;
    
    //--//
    [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];

}


- (void)saveToken:(NSString *)token {

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (token) {
        
        return YES;
    } else {
    
    
        return NO;
    }

}



- (void)loginOut {

    self.userId = nil;
    self.token = nil;
    self.totalFansNum = nil;
    self.totalFollowNum = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.userExt = nil;
    self.tradepwdFlag = nil;
    self.level = nil;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_out_notification" object:nil];
}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
        
        @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (TLUserExt *)userExt {

    if (!_userExt) {
        _userExt = [[TLUserExt alloc] init];
        
    }
    return _userExt;

}

- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
//        NSLog(@"原%@--现%@",[TLUser user].userId,responseObject[@"data"][@"userId"]);
//        if (![[TLUser user].userId isEqualToString:responseObject[@"data"][@"userId"]]) {
//            
//            @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
//            
//        }
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)setUserInfoWithDict:(NSDictionary *)dict {

    self.userId = dict[@"userId"];
    
    //token用户信息没有返回，不能再此处初始化
//    self.token = dict[@"token"];
    self.mobile = dict[@"mobile"];
    self.nickname = dict[@"nickname"];
    self.realName = dict[@"realName"];
    self.idNo = dict[@"idNo"];
    self.tradepwdFlag = dict[@"tradepwdFlag"];
    self.level = dict[@"level"];
    
    //--//
    self.totalFollowNum = dict[@"totalFollowNum"];
    self.totalFansNum = dict[@"totalFansNum"];

    
    NSDictionary *userExt = dict[@"userExt"];
    if (userExt) {
        if (userExt[@"photo"]) {
            self.userExt.photo = userExt[@"photo"];
        }
        
        if (userExt[@"province"]) {
            self.userExt.province = userExt[@"province"];
        }
        
        if (userExt[@"city"]) {
            self.userExt.city = userExt[@"city"];
        }
        
        if (userExt[@"area"]) {
            self.userExt.area = userExt[@"area"];
        }
        
        //性别
        if (userExt[@"gender"]) {
            self.userExt.gender = userExt[@"gender"];
        }
        
        //生日
        if (userExt[@"birthday"]) {
            self.userExt.birthday = userExt[@"birthday"];
        }
        
        //email
        if (userExt[@"email"]) {
            self.userExt.email = userExt[@"email"];
        }
        
        //介绍
        if (userExt[@"introduce"]) {
            self.userExt.introduce = userExt[@"introduce"];
        }
        
        
    }

    
}


- (NSString *)detailAddress {

    if (!self.userExt.province) {
        return @"未知";
    }
    return [NSString stringWithFormat:@"%@ %@ %@",self.userExt.province,self.userExt.city,self.userExt.area];

}


@end
