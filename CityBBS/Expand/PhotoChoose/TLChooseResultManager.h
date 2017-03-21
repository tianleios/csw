//
//  TLChooseResultManager.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLPhotoChooseItem;

@interface TLChooseResultManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *>*hasChooseItems;
@property (nonatomic, assign) NSInteger maxCount;


@end
