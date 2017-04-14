//
//  CSWForumGeneraCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWForumGeneraCell.h"

@interface CSWForumGeneraCell()



@end

@implementation CSWForumGeneraCell

+ (CSWForumGeneraCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath  {

    CSWForumGeneraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWForumGeneraCellId"];
    if (!cell) {
        
        cell = [[CSWForumGeneraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWForumGeneraCellId"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        
    }
    
    return cell;


}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(15)
                                 textColor:[UIColor textColor]];
        
        [self.contentView addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        _nameLbl.text = @"论坛分类A";
    }
    
    return self;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
