//
//  CSWPlateHeaderView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWPlateHeaderView.h"

@implementation CSWPlateHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //
        self.plateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self addSubview:self.plateImageView];
       
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.plateImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(23);
        }];
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.plateImageView.mas_bottom).offset(15);
        }];
        
        //
        UIView *v = [self topArticleWithFrame:CGRectMake(0, self.plateImageView.yy + 15 + 1, self.width, 45)];
        [self addSubview:v];
        
        //底部更多
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, v.yy, self.width, 40)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"更多帖子"] forState:UIControlStateNormal];
        [self addSubview:moreBtn];
        [moreBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = FONT(14);
        moreBtn.backgroundColor = [UIColor whiteColor];
        moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, -55);
        
        //站位
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, moreBtn.yy, self.width, 10)];
        [self addSubview:placeholderView];
        placeholderView.backgroundColor = [UIColor backgroundColor];
        self.height = placeholderView.yy;
        
    }
    return self;
}


- (UIView *)topArticleWithFrame:(CGRect)frame {

    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
//    //uil
    UILabel *hintlbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor themeColor]
                                          font:FONT(13)
                                     textColor:[UIColor whiteColor]];
    [bgView addSubview:hintlbl];
    hintlbl.layer.cornerRadius = 3;
    hintlbl.layer.masksToBounds = YES;
    [hintlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.height.equalTo(@23);
        make.width.equalTo(@38);
        
    }];
//    
//    //
    UILabel *contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(15)
                                        textColor:[UIColor textColor]];
    [bgView addSubview:contentLbl];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(hintlbl.mas_right).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        
        
    }];
//

//
//    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left);
        make.width.equalTo(bgView.mas_width);
        make.height.mas_equalTo(@(LINE_HEIGHT));
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
        contentLbl.text = @"永嘉城市网介绍";
    hintlbl.text = @"置顶";
    return bgView;

}

@end
