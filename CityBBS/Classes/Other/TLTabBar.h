//
//  TLTabBar.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLTabBar;

@protocol TLTabBarDelegate <NSObject>

- (void)didSelected:(NSInteger)idx tabBar:(TLTabBar *)tabBar;
- (void)didSelectedMiddleItemTabBar:(TLTabBar *)tabBar;


@end


@interface TLTabBar : UITabBar

@property (nonatomic, weak) id<TLTabBarDelegate> tl_delegate;

@property (nonatomic, strong) NSArray *tabNames;

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
