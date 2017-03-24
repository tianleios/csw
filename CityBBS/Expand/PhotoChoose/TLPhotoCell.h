//
//  TLPhotoCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoChooseItem.h"

@interface TLPhotoCell : UICollectionViewCell

@property (nonatomic, strong) TLPhotoChooseItem *photoItem;

//@property (nonatomic, copy) void(^chooseHandle)(TLPhotoChooseItem *item,BOOL isChoose);

@end
