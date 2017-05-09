//
//  TLBannerCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSWBannerModel;
@interface TLDisplayBannerCell : UICollectionViewCell

@property (nonatomic, strong) TLBannerView *bannerView;

+ (NSString *)reuseId;
@property (nonatomic, copy) NSArray <CSWBannerModel *>*bannerRoom;


@end

