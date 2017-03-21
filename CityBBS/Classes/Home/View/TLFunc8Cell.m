//
//  TLFunc8Cell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLFunc8Cell.h"

@interface TLFunc8Cell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLbl;

@end


@implementation TLFunc8Cell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = [UIColor lineColor].CGColor;
        self.bgView.layer.masksToBounds = YES;
        
        //
        self.typeImageView = [[UIImageView alloc] init];
        self.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.typeImageView];
        [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(26);
            make.top.equalTo(self.contentView.mas_top).offset(15);

        }];
        
        //lbl
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor
                                                 ]
                                           font:FONT(11)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeImageView.mas_bottom).offset(7);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        [self data];
        
    }
    return self;
}

- (void)data {
    
    self.typeImageView.image = [UIImage imageNamed:@"二手"];
    self.titleLbl.text = @"招聘";
    
}

+ (NSString *)reuseId {

    return @"tlFunc8CellId";

}

@end
