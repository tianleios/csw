//
//  TLPlateChooseCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPlateChooseCell.h"



@implementation TLPlateChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        self.imageView.layer.cornerRadius = 25;
        self.imageView.backgroundColor = [UIColor orangeColor];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);

        }];
        
        //
        self.titleLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]
                                            font:FONT(11)
                                       textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.imageView.mas_bottom).offset(7);
            make.width.equalTo(self.contentView.mas_width);
            make.left.equalTo(self.contentView.mas_left);
            
        }];
        
        
    }
    return self;
}
@end
