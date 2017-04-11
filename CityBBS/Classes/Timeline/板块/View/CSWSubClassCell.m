//
//  CSWSubClassCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSubClassCell.h"


@interface CSWSubClassCell()

@property (nonatomic, strong) UIImageView *subClassImageView;
@property (nonatomic, strong) UILabel *nameLbl;

@end


@implementation CSWSubClassCell

+ (CSWSubClassCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath  {
    
    CSWSubClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSubClassCellId"];
    if (!cell) {
        
        cell = [[CSWSubClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSubClassCellId"];
    }
    
    return cell;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //
        self.subClassImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.subClassImageView];
        [self.subClassImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);

        }];
        
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(15)
                                 textColor:[UIColor textColor]];
        
        [self.contentView addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.subClassImageView.mas_right).offset(12);
            make.top.equalTo(self.subClassImageView.mas_top).offset(10);
            
        }];
        
        //
        UIButton *  comeInBtn = [[UIButton alloc] init];
        [self.contentView addSubview:comeInBtn];
        [comeInBtn setTitle:@"进入" forState:UIControlStateNormal];
        [comeInBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        comeInBtn.layer.cornerRadius = 4;
        comeInBtn.layer.masksToBounds = YES;
        comeInBtn.layer.borderColor = [UIColor themeColor].CGColor;
        comeInBtn.layer.borderWidth  = 0.8;
        comeInBtn.titleLabel.font = FONT(12);
        [comeInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
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
    
    [self data];
    return self;
    
}


- (void)data {

    self.subClassImageView.backgroundColor = [UIColor orangeColor];
    self.nameLbl.text = @"板块名称";
    
}


@end
