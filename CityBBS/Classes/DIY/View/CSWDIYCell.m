//
//  CSWDIYCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYCell.h"

@interface CSWDIYCell()

@property (nonatomic, strong) UIImageView *displayImageView;
@property (nonatomic, strong) UILabel *introduceLbl;

@end

@implementation CSWDIYCell

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
        self.introduceLbl.text = @"你们在家";
//        if (random()%2 == 1) {
//            self.introduceLbl.text = @"fjkaljdfalkjfklajsdlkfjkla计费的卡拉胶付款啦";
//
//        } else {
//            
//            self.introduceLbl.text = @"fjkaljdfalkjfklfjkaljdfalkjfklajsdlkfjklafjkaljdfalkjfklajsdlkfjklaajsdlkfjkla计费的卡拉胶付款啦";
//
//        }
        
        
        //
        [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((SCREEN_WIDTH - 5)/2.0);
            make.bottom.equalTo(self.introduceLbl.mas_bottom);
            make.top.equalTo(self.displayImageView.mas_top);
        }];
        
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {

    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size]; // 获取自适应size
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    newFrame.size.width = (SCREEN_WIDTH - 5)/2.0; // 不同屏幕适配
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
@end
