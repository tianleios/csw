//
//  CSWArticleTypeSwitchView.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWArticleTypeSwitchView : UIView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat intervalMargin;
@property (nonatomic, copy) NSArray <NSString *>*typeNames;

@property (nonatomic, copy) void(^selected)(NSInteger idx);
@property (nonatomic, assign) NSInteger selectedIdx;

@end
