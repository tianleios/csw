//
//  ZHCaptchaView.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAccountTf.h"
@interface TLDIYCaptchaView : UIView

@property (nonatomic,strong) TLAccountTf *captchaTf;
@property (nonatomic,strong) TLTimeButton *captchaBtn;

@end
