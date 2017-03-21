//
//  TLPhotoItem.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TLPhotoChooseItem : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *thumbnailImg;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, assign) BOOL isCamera;

@property (nonatomic, assign) BOOL isSelected;


@end
