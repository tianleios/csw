//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLTabBarController.h"
#import "TLNavigationController.h"
#import "CSWTimeLineVC.h"
#import "TLTabBar.h"
#import "TLComposeVC.h"
#import "TLUserLoginVC.h"

@interface TLTabBarController ()<UITabBarControllerDelegate,TLTabBarDelegate>

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    NSArray *titles = @[@"头条",@"有料",@"DIY",@"我的"];
    //, BPProjectCategoryVC  BPSubscriptionVC
    
    
//    @"ZHMineVC"  ZHMineViewCtrl  TLHomeVC
    NSArray *VCNames = @[@"TLHomeVC",@"CSWTimeLineVC",@"CSWDIYVC",@"CSWMineVC"];
    NSArray *imageNames = @[@"头条_un",@"有料_un",@"视频_un",@"我的_un"];
    NSArray *selectedImageNames = @[@"头条",@"有料",@"视频",@"我的"];
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    

//            self.selectedIndex = 2;

//    //消息变更
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMsgChange) name:kUnreadMsgChangeNotification object:nil];
//    
//    //退出通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usrLoginOut) name:kUserLoginOutNotification object:nil];
//    
//    //退出通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];

    
    //替换系统tabbar
    TLTabBar *tabBar = [[TLTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.translucent = NO;
    tabBar.tl_delegate = self;
    tabBar.backgroundColor = [UIColor orangeColor];
    [self setValue:tabBar forKey:@"tabBar"];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];

}

#pragma mark- cityChange
- (void)cityChange {

    TLTabBar *tabbar = (TLTabBar *)self.tabBar;
//    tabbar.tabNames = @[@"头条",@"有料",@"DIY",@"我的"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //
    [[CSWCityManager manager].tabBarRoom enumerateObjectsUsingBlock:^(CSWTabBarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLTabBarItem *tabBarItem = [TLTabBarItem new];
        tabBarItem.title = obj.name;
        tabBarItem.selectedImgUrl = [obj.selectedImageUrl convertImageUrlWithScale:100];
        tabBarItem.unSelectedImgUrl = [obj.unSelectedImageUrl convertImageUrlWithScale:100];
        [arr addObject:tabBarItem];
        
    }];
    
    //
    tabbar.tabBarItems = arr;

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self cityChange];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    


}


#pragma mark- tabbar-delegate
- (BOOL)didSelected:(NSInteger)idx tabBar:(TLTabBar *)tabBar {

    if (idx == 3 && ![TLUser user].isLogin) {
        
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    //
    self.selectedIndex = idx;
    return YES;
   
}

- (BOOL)didSelectedMiddleItemTabBar:(TLTabBar *)tabBar {

    if ([TLUser user].isLogin) {
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:[TLComposeVC new]];
        [self presentViewController:nav animated:YES completion:nil];
        
        return YES;
    }
    
    TLUserLoginVC *loginVC = [TLUserLoginVC new];
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    return NO;

}



- (void)usrLoginOut {

    self.tabBar.items[3].badgeValue =  nil;
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)userLogin {

    [self unreadMsgChange];
    
}

- (void)unreadMsgChange {

//    NSInteger count = [[ChatManager defaultManager] unreadMsgCount];
//    if (count <= 0) {
//       
//        self.tabBar.items[3].badgeValue = nil;
//        
//    } else {
//        
//      self.tabBar.items[3].badgeValue =  [NSString stringWithFormat:@"%ld",count];
//
//    }
//    
//   [UIApplication sharedApplication].applicationIconBadgeNumber = [ChatManager defaultManager].unreadMsgCount;
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
//    //登录
//    if ([[TLUser user] isLogin]) {
//        
//        return YES;
//    }
//    
//    //未登录
//    UINavigationController *mineNav = tabBarController.viewControllers[4];
//    UINavigationController *chatNav = tabBarController.viewControllers[3];
//    UINavigationController *sendToSendNav = tabBarController.viewControllers[1];
//
//
//    if ([mineNav isEqual:viewController]) {
//        
//            
//            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//            loginVC.loginSuccess = ^(){
//            
//                self.selectedIndex = 4;
//            };
//            [self presentViewController:nav animated:YES completion:nil];
//            return NO;
//            
//        
//    } else if([chatNav isEqual:viewController]) {
//    
//        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        loginVC.loginSuccess = ^(){
//            
//            self.selectedIndex = 3;
//            
//        };
//        [self presentViewController:nav animated:YES completion:nil];
//        return NO;
//        
//    } else if([sendToSendNav isEqual:viewController]) {
//        
//        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        loginVC.loginSuccess = ^(){
//            
//            self.selectedIndex = 1;
//            
//        };
//        [self presentViewController:nav animated:YES completion:nil];
//        
//    
//        return NO;
//    } else {
//    
//        return YES;
//    }


}


//--//
- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor themeColor]
                                         } forState:UIControlStateSelected];
    vc.tabBarItem =tabBarItem;
    TLNavigationController *navigationController = [[TLNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image
{
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
