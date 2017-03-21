//
//  ZHSettingGroup.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSettingModel.h"

@interface TLSettingGroup : NSObject

@property (nonatomic,copy) NSArray <TLSettingModel *>*items;

@end
