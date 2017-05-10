//
//  CSWFansVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, CSWReleationType) {
    CSWReleationTypeFans = 0,
    CSWReleationTypeFocus = 1
};


@interface CSWFansVC : TLBaseVC

@property (nonatomic, assign) CSWReleationType type;

@end
