//
//  TLArticleCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSWArticleModel;

@interface TLArticleCell : UICollectionViewCell

+ (NSString *)reuseId;
@property (nonatomic, strong) CSWArticleModel *articleModel;

@end
