//
//  TLBarButton.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBarButton : UIButton


@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) BOOL isCurrentSelected;


@end
