//
//  CSWTimeLineCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWLayoutItem.h"

@interface CSWTimeLineCell : UITableViewCell

//关注按钮
@property (nonatomic, strong) UIButton *focusBtn;

//关注,用来操作关注按钮
- (void)focusing;
- (void)unFocus;



@property (nonatomic, strong) CSWLayoutItem *layoutItem;

@end
