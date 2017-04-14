//
//  UIResponder+TLAdd.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UIResponder+TLAdd.h"

@implementation UIResponder (TLAdd)

- (UIViewController *)nextViewController {

    if ([self isKindOfClass:[UIViewController class]]) {
        
        return (UIViewController *)self;
    }
    
    UIResponder *responder = self;
    do {
        responder = [responder nextResponder];
        
    } while (![responder isMemberOfClass:[UIViewController class]]);
    
    return (UIViewController *)responder;

}

- (UINavigationController *)nextNavController {
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        
        return (UINavigationController *)self;
    }
    
    UIResponder *responder = self;
    do {
        
        responder = [responder nextResponder];
        
//        if ([responder isKindOfClass:[UIWindow class]]) {
//            break;
//        }
        
    } while (![responder isKindOfClass:[UINavigationController class]]);
    
    return (UINavigationController *)responder;
    
}

@end
