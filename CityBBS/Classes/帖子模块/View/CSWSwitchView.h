//
//  CSWSwitchView.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWSwitchView : UIView

@property (nonatomic, copy) void(^selected)(NSInteger idx);

@property (nonatomic, assign) NSInteger selectedIndex;

@end
