//
//  CSWDIYCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYCell.h"
#import "CSWVideoModel.h"

@interface CSWDIYCell()

@property (nonatomic, strong) UIImageView *displayImageView;
@property (nonatomic, strong) UILabel *introduceLbl;

@end

@implementation CSWDIYCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.displayImageView = [[UIImageView alloc] init];
        self.displayImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.displayImageView];
        self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(100);
            
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
            make.height.mas_equalTo(20);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        }];

        
        
        //
//        [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo((SCREEN_WIDTH - 5)/2.0);
//            make.bottom.equalTo(self.introduceLbl.mas_bottom);
//            make.top.equalTo(self.displayImageView.mas_top);
//        }];
        
    }
    return self;
}

- (void)setVideoModel:(CSWVideoModel *)videoModel {

    _videoModel = videoModel;
    
    [self.displayImageView sd_setImageWithURL:[NSURL URLWithString:[_videoModel.pic convertImageUrl]] placeholderImage:nil];
    self.introduceLbl.text = _videoModel.name;


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
