//
//  TLPlateChooseView.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPlateChooseView : UIView

- (void)show;
- (void)dismiss;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) void(^choosePlate)(NSInteger idx);

@end
