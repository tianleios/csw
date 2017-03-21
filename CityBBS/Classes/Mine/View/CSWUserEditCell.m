//
//  CSWUserEditCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserEditCell.h"

@implementation CSWUserEditCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //标题
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        
        //内容
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor]
                                             font:FONT(15)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.contentLbl];
        
        self.userPhoto = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userPhoto];
        self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        self.userPhoto.clipsToBounds = YES;
        

        
        //
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentLbl.mas_left);
        }];

        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.titleLbl.mas_right);
        }];
        
        [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.equalTo(self.contentView.mas_right);
            make.width.mas_equalTo(60);


        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;

}

@end
