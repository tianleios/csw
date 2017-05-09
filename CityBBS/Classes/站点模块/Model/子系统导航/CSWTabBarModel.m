//
//  CSWTabBarModel.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWTabBarModel.h"

@implementation CSWTabBarModel

- (void)setPic:(NSString *)pic {

    _pic = [pic copy];
    NSArray <NSString *>*imgs = [_pic componentsSeparatedByString:@"||"];
    
    if (imgs.count > 1) {
        
        self.unSelectedImageUrl = imgs[0];
        self.selectedImageUrl = imgs[1];
        
    } else  {
    
        self.unSelectedImageUrl = imgs[0];
        self.selectedImageUrl = imgs[0];
    }
    
}


@end
