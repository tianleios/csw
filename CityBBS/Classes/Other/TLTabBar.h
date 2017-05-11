//
//  TLTabBar.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTabBarItem.h"

@class TLTabBar;

@protocol TLTabBarDelegate <NSObject>


/**
 点击tabbarbutton 会先调用此方法，返回yes 正常切换，NO不进行切换

 @param idx
 @param tabBar
 @return 是否切换
 */
- (BOOL)didSelected:(NSInteger)idx tabBar:(TLTabBar *)tabBar;
- (BOOL)didSelectedMiddleItemTabBar:(TLTabBar *)tabBar;


@end


@interface TLTabBar : UITabBar

@property (nonatomic, weak) id<TLTabBarDelegate> tl_delegate;

@property (nonatomic, copy) NSArray *tabNames;

@property (nonatomic, copy) NSArray <TLTabBarItem *>*tabBarItems;
@property (nonatomic, assign) NSInteger selectedIdx;


@end

