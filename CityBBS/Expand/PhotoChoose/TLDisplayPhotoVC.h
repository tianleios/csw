//
//  TLDisplayPhotoVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLImagePickerControllerDelegate.h"

@class TLPhotoChooseItem;

@protocol TLImagePickerControllerDelegate ;

@interface TLDisplayPhotoVC : UIViewController

@property (nonatomic, weak) id<TLImagePickerControllerDelegate> delegate;
@property (nonatomic, weak) TLImagePickerController *pickerCtrl;

@property (nonatomic, copy) NSArray <TLPhotoChooseItem *>*replacePhotoItems;

@end
