//
//  CSWCommentLayoutItem.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSWCommentModel.h"

@interface CSWCommentLayoutItem : NSObject

@property (nonatomic, strong) CSWCommentModel *commentModel;
@property (nonatomic, assign) CGRect commentFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSAttributedString *commentAttrStr;
@end
