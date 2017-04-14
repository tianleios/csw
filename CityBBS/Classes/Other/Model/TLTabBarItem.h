//
//  TLTabBarItem.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLTabBarItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedImgUrl;
@property (nonatomic, copy) NSString *unSelectedImgUrl;
@property (nonatomic, assign) BOOL isSelected;

@end
