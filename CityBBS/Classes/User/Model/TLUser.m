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

#define USER_ID_KEY @"user_id_key_zh"
#define TOKEN_ID_KEY @"token_id_key_zh"
#define USER_INFO_DICT_KEY @"user_info_dict_key_zh"

NSString *const kUserLoginNotification = @"kUserLoginNotification_zh";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification_zh";
NSString *const kUserInfoChange = @"kUserInfoChange_zh";

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
- (void)keyChainStore {

    UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:@"zh_bound_id"];
    
    //存值
    [keyChainStore setString:@"" forKey:@""];
    //取值
    [keyChainStore stringForKey:@""];

}

- (void)setUserId:(NSString *)userId {

    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setToken:(NSString *)token {

    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (void)initUserData {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    
    self.userId = userId;
    self.token = token;
    
    //--//
    [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];

}

- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
        
//        self.userId = userId;
//        self.token = token;
//        [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];
        
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_out_notification" object:nil];
}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    
    //
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)setUserInfoWithDict:(NSDictionary *)dict {

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
