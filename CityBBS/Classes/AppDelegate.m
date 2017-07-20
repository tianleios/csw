//
//  AppDelegate.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//  https://realm.io/cn/docs/objc/latest/

#import "AppDelegate.h"
#import "TLTabBarController.h"
#import "IQKeyboardManager.h"
#import "TLComposeVC.h"
#import "AppConfig.h"
#import "AppDelegate+Chat.h"
#import "SVProgressHUD.h"
#import "TLComposeArticleItem.h"
#import "CSWLoadRootVC.h"
#import "CSWArticleDetailVC.h"
#import "CSWSendCommentVC.h"
#import "ChatManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    branch_A
    //2.应用环境
    [AppConfig config].runEnv = RunEnvDev;
    
    //
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[TLComposeVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[CSWArticleDetailVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[CSWSendCommentVC class]];
    
     [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[CSWArticleDetailVC class]];

    //ProgressHUD
    [SVProgressHUD setMaximumDismissTimeInterval:7];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    
    
    //1.出事化环信
    [self chatInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[CSWLoadRootVC alloc] init];

    //取出用户信息
    if([TLUser user].isLogin) {
    
        [[TLUser user] initUserData];
        
        //异步跟新用户信息
        [[TLUser user] updateUserInfo];
        
    };
    
    //
    return YES;
    
}

#pragma mark- 加载应用主体
- (void)loadRoot {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[TLTabBarController alloc] init];

}


- (void)userLoginOut {

    [[TLUser user] loginOut];
    [[ChatManager defaultManager] chatLoginOut];

}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
