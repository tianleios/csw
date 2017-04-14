//
//  CSWForumGeneraCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWForumGeneraCell : UITableViewCell

+ (CSWForumGeneraCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UILabel *nameLbl;


@end
