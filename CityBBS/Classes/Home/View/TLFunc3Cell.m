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
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
//        self.bgImageView.backgroundColor = [UIColor orangeColor];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        self.bgImageView.layer.cornerRadius = 3;
        self.bgImageView.layer.masksToBounds = YES;
        
        
        //lbl
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(14)
                                      textColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
                
    }
    return self;
}



- (void)setFuncModel:(CSWFuncModel *)funcModel {

    _funcModel = funcModel;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[_funcModel.pic convertOriginalImgUrl]] placeholderImage:nil];

    self.titleLbl.text = _funcModel.name;
}

+ (NSString *)reuseId {
    
    return @"tlFunc3CellId";
    
}

@end
