//
//  TLPhotoChooseCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoItem.h"

@interface TLPhotoChooseCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteItem)(UICollectionViewCell *cell);
@property (nonatomic, copy) void(^add)();

//@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) TLPhotoItem *phototItem;


@end
