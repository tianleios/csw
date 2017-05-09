//
//  CSWDaShangUserCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/5/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDaShangUserCell.h"

//@interface CSWDaShangUserCell()
//
//@property (nonatomic, strong) UIImageView *userPhoto;
//@property (nonatomic, strong) UILabel *userNameLbl;
//
//@end

@implementation CSWDaShangUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        self.userPhoto = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userPhoto];
         self.userPhoto.layer.cornerRadius = 17;
         self.userPhoto.layer.masksToBounds = YES;
        
        
        [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(34);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        
        //lbl
        self.userNameLbl = [[UILabel alloc] init];
        self.userNameLbl.textColor = [UIColor textColor];
        self.userNameLbl.font = FONT(13);
        
        [self.contentView addSubview:self.userNameLbl];
        
        [self.userNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userPhoto.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(self.contentView.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
     
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
