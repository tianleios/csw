//
//  ZHNavigationController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLNavigationController.h"

@interface TLNavigationController ()

@end

@implementation TLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
//    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
//    self.navigationBar.backgroundColor = [UIColor themeColor];
    
    [UINavigationBar appearance].barTintColor = [UIColor themeColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];

    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    
//    self.navigationBar.barTintColor = [UIColor themeColor];
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationBar.translucent = NO;
//    self.navigationBar.barStyle = UIBarStyleBlack;

    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
   

    }
    [super pushViewController:viewController animated:YES];

}

- (void)back {

    [self popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
