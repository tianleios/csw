//
//  CSWGoodsCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWGoodsCell.h"

@interface CSWGoodsCell()

@property (nonatomic, strong) UIImageView *displayImageView;
@property (nonatomic, strong) UILabel *introduceLbl;

@end

@implementation CSWGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.displayImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.displayImageView];
        [self.displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(80);
            
        }];
        
        //
        self.introduceLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:FONT(14)
                                          textColor:[UIColor textColor]];
        [self.contentView addSubview:self.introduceLbl];
        self.introduceLbl.numberOfLines = 0;
        [self.introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.top.equalTo(self.displayImageView.mas_bottom).offset(5);
            //            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        

    }
    
    return self;
    
}


@end
