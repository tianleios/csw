//
//  AppConfig.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppConfig.h"


void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {

    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });

    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {

    _runEnv = runEnv;
    switch (_runEnv) {
            
        case RunEnvRelease: {
        
           self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
           self.chatKey = @"1139170317178872#zhpay";
            
           self.addr = @"http://139.224.200.54:5601"; //test
           //分享的基础连接
//          http://121.43.101.148:5603/share/share-receive.html?code=xxx&userReferee=xxx
            self.shareBaseUrl = @"http://m.zhenghuijituan.com";

        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
            self.chatKey = @"1139170317178872#zhpay";
            self.addr = @"http://118.178.124.16:5601";
            self.shareBaseUrl = @"http://118.178.124.16:5603";
            
        }break;
            
            
        case RunEnvDev: {
            
//            self.qiniuDomain = @"http://oi99f4peg.bkt.clouddn.com";
//            self.chatKey = @"tianleios#cd-test";
            self.qiniuDomain = @"http://oigx51fc5.bkt.clouddn.com";
            self.chatKey = @"tianleios#cd-test";
            self.systemCode = @"CD-CCSW000008";
            self.addr = @"http://121.43.101.148:8901";
            self.shareBaseUrl = @"http://121.43.101.148:5603";
            
        }break;
   

    }
    
} 

- (NSString *)pushKey {

    return @"552c967a30325e9374a6ea2a";
    
}


- (NSString *)aliMapKey {

    return @"a3bd76e7d3689fccd4604861cc83450e";
}


- (NSString *)wxKey {

    return @"wx1c40c1c60500a270";
}

@end
