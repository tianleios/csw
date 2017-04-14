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

- (BOOL)didSelected:(NSInteger)idx tabBar:(TLTabBar *)tabBar;
- (BOOL)didSelectedMiddleItemTabBar:(TLTabBar *)tabBar;


@end


@interface TLTabBar : UITabBar

@property (nonatomic, weak) id<TLTabBarDelegate> tl_delegate;

@property (nonatomic, copy) NSArray *tabNames;

@property (nonatomic, copy) NSArray <TLTabBarItem *>*tabBarItems;

@end

//@interface TLImageView : UIImageView
//
//
//@end
//
//@interface TLBGView : UIView
//
//
//@end
