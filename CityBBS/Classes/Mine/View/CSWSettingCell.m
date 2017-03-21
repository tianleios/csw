//
//  CSWSettingCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSettingCell.h"

@interface CSWSettingCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *accessoryImageView;


@end

@implementation CSWSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);

        }];
        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        self.accessoryImageView.image = [UIImage imageNamed:@"mine_more"];
        
        //
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(20);
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left);;
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

- (void)setSettingModel:(TLSettingModel *)settingModel {

    self.iconImageView.image = [UIImage imageNamed:settingModel.imgName];
    self.titleLbl.text = settingModel.text;
    
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
