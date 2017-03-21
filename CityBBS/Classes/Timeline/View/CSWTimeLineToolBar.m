//
//  ZHTimeLineToolBar.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWTimeLineToolBar.h"

@interface CSWTimeLineToolBar()

@property (nonatomic, strong) UIButton *shareBtn;

//点赞
@property (nonatomic, strong) UIButton *dzBtn;
@property (nonatomic, strong) UILabel *dzCountLbl;

//评论
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *commentCountLbl;

@end

@implementation CSWTimeLineToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //分享
        self.shareBtn = [[UIButton alloc] init];
        [self addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
            
        }];
        
        //评论
        self.commentCountLbl = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentRight
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(12)
                                             textColor:[UIColor textColor]];
        [self addSubview:self.commentCountLbl];
        [self.commentCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.shareBtn.mas_top);
            make.height.equalTo(self.mas_height);
        }];
        
        
        self.commentBtn = [[UIButton alloc] init];
        [self addSubview:self.commentBtn];
         self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.shareBtn.mas_top);
            make.right.equalTo(self.commentCountLbl.mas_left).offset(-3);
            
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
            
        }];
        
        //点赞
        self.dzCountLbl = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentRight
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(12)
                                             textColor:[UIColor textColor]];
        [self addSubview:self.dzCountLbl];
        [self.dzCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareBtn.mas_top);
            make.right.equalTo(self.commentBtn.mas_left).offset(-15);
            make.height.equalTo(self.mas_height);

        }];
        
        self.dzBtn = [[UIButton alloc] init];
        [self addSubview:self.dzBtn];
        self.dzBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self.dzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.dzCountLbl.mas_left).offset(-4);
            make.top.equalTo(self.shareBtn.mas_top);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(18);
            
        }];
        
        
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"time_line_share_highlight"] forState:UIControlStateNormal];
        
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"time_line_comment"] forState:UIControlStateNormal];
        
        [self.dzBtn setBackgroundImage:[UIImage imageNamed:@"time_line_dz"] forState:UIControlStateNormal];
        
        //--//
        self.dzCountLbl.text = @"100";
        self.commentCountLbl.text = @"10000";
        
    }
    return self;
}

@end
