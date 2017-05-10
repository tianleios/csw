//
//  CSWFansCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWFansCell.h"
#import "CSWRelationUserModel.h"

@interface CSWFansCell()

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *nameLbl;
//@property (nonatomic, strong) UILabel *numLbl;


@end

@implementation CSWFansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        self.userPhoto = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userPhoto];
        self.userPhoto.layer.masksToBounds = YES;
        self.userPhoto.layer.cornerRadius = 20;

        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:FONT(14)
                                          textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.nameLbl];
        
//        //
//        self.numLbl = [UILabel labelWithFrame:CGRectZero
//                                  textAligment:NSTextAlignmentLeft
//                               backgroundColor:[UIColor whiteColor]
//                                          font:FONT(12)
//                                     textColor:[UIColor colorWithHexString:@"#999999"]];
//        [self.contentView addSubview:self.numLbl];
        
        
        //约束
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userPhoto.mas_right).offset(10);
            make.centerY.equalTo(self.userPhoto.mas_centerY);
            
        }];
        
//        [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLbl.mas_left);
//            make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
//            //make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
//        }];
        
        [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
            
        }];
    }
    
    return self;

}

- (void)setUser:(CSWRelationUserModel *)user {

    _user = user;
    
    if (user.photo) {
       
        //--//
        NSString *urlStr = [user.photo convertThumbnailImageUrl];
        [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:USER_PLACEHOLDER_SMALL];
        
    } else {
    
        self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    
    }
 
    self.nameLbl.text = user.nickname;
    
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
