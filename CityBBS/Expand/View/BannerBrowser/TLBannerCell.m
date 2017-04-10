//
//  XNBannerCell.m
//  MOOM
//
//  Created by 田磊 on 16/4/12.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLBannerCell.h"
#import "UIImageView+WebCache.h"
@interface TLBannerCell ()

@property (nonatomic,weak) UIImageView *imageIV;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation TLBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:iv];
        iv.clipsToBounds = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIV = iv;
        
        
        //
        UIView *bgV = [[UIView alloc] init];
        bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.contentView addSubview:bgV];
        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(35);
        }];
        
        
        [[UIColor blackColor] colorWithAlphaComponent:0.2];
        //底部
        UILabel *titleLbl = [UILabel labelWithFrame:CGRectZero
                                        textAligment:NSTextAlignmentLeft
                                     backgroundColor:[UIColor clearColor
                                                      ]
                                                font:FONT(16)
                                           textColor:[UIColor whiteColor]];
        [bgV addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        //
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, -15));
        }];
        
//        titleLbl.text = @"橙袋科技征文启事";
        
    }
    return self;
}


- (void)setBanner:(TLBannerModel *)banner {

    _banner = banner;

    self.titleLbl.text = banner.title;

    if ([_banner.imgUrl hasPrefix:@"http:"]) { //网络图片
        
        NSURL *url = [NSURL URLWithString:_banner.imgUrl];
        [_imageIV sd_setImageWithURL:url placeholderImage:nil];
        
    } else { //本地图片
        
        self.imageIV.image = [UIImage imageWithContentsOfFile:_banner.imgUrl];
        
    }
}





@end
