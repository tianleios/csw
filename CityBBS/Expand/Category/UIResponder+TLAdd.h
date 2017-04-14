//
//  UIResponder+TLAdd.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (TLAdd)

- (UIViewController *)nextViewController;
- (UINavigationController *)nextNavController;

@end
