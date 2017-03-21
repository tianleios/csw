//
//  TLFunc3Cell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLFunc3Cell.h"

@interface TLFunc3Cell()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLbl;



@end

@implementation TLFunc3Cell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        //lbl
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor
                                                                                                               ]
                                           font:FONT(14)
                                      textColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self data];
        
    }
    return self;
}

- (void)data {

    self.bgImageView.image = [UIImage imageNamed:@"积分商城"];
    self.titleLbl.text = @"积分商城";

}

+ (NSString *)reuseId {
    
    return @"tlFunc3CellId";
    
}

@end
