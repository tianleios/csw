//
//  TLFunc8Cell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSWFuncModel;
@interface TLFunc8Cell : UICollectionViewCell

+ (NSString *)reuseId;
@property (nonatomic, strong) CSWFuncModel *funcModel;

@end
