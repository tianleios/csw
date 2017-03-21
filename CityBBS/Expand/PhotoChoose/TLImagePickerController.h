//
//  TLImagePickerController.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLImagePickerControllerDelegate.h"

@class TLImagePickerController;


@interface TLImagePickerController : UINavigationController

- (instancetype)initWithDelegate:(id<TLImagePickerControllerDelegate>)delegate;


@property (nonatomic, weak) id<TLImagePickerControllerDelegate> delegate;

@end
