//
//  TLHeader.h
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#ifndef TLHeader_h
#define TLHeader_h

#import "APICodeHeader.h"

#import "TLAlert.h"
#import "TLAuthHelper.h"

#import "TLBaseModel.h"
#import "NSNumber+TLAdd.h"
#import "UIViewController+Extension.h"

#import "TLTableView.h"
#import "TLTextField.h"
#import "TLTimeButton.h"
#import "TLBannerView.h"
#import "TLCaptchaView.h"
#import "TLPlaceholderView.h"
#import "TLPageDataHelper.h"
#import "TLProgressHUD.h"


#import "TLNetworking.h"
#import "UIView+Frame.h"
#import "UIColor+Extension.h"
#import "Foundation+Log.m"
#import "MBProgressHUD+add.h"
#import "UIImageView+WebCache.h"


#import "UILable+convience.h"
#import "UIButton+convience.h"
#import "NSString+Extension.h"
#import "NSAttributedString+add.h"
#import "TLBaseVC.h"
#import "TLUser.h"
#import "Masonry.h"


#import "NSObject+convert.h"
#import "Foundation+Log.m"
#import "NSDate+TLAdd.h"
#import "UIFont+UI.h"
#import "UIImage+TLAdd.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE (([UIScreen mainScreen].bounds.size.width)/375.0)
#define FONT(x)    [UIFont systemFontOfSize:x]
#define LEFT_MARGIN 15
#define LINE_HEIGHT 0.7


#endif /* TLHeader_h */
