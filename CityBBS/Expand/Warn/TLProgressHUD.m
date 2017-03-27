//
//  TLProgressHUD.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLProgressHUD.h"

@implementation TLProgressHUD

+ (void)showWithStatus:(NSString *)msg {
    
    [super showWithStatus:msg];
    
}

+ (void)showInfoWithStatus:(NSString *)status {

    [super showInfoWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)status {

    [super showSuccessWithStatus:status];

}


+ (void)showErrorWithStatus:(NSString *)status {

    [super showErrorWithStatus:status];

}


+ (void)dismiss {
    
    [super dismiss];
}


+ (void)showWithStatusAutoDismiss:(NSString *)msg {

    [self showWithStatusAutoDismiss:msg delay:3 completion:nil];

}

+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime  {
    
    [self showWithStatusAutoDismiss:msg delay:delayTime completion:nil];
    
}

+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime  completion:(void(^)())completion {

    [self showWithStatus:msg];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self dismissWithDelay:delayTime completion:completion];
    

}



@end
