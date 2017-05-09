//
//  TLArticleCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLArticleCell.h"
#import "CSWArticleModel.h"

@interface TLArticleCell()

@property (nonatomic, strong) UIImageView *contentImg;
@property (nonatomic, strong) UILabel *textLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *readNumLbl;

@end


@implementation TLArticleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.contentView.mas_top);
        }];
        
        //
        self.contentImg = [[UIImageView alloc] init];
        self.contentImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.contentImg];
        self.contentImg.clipsToBounds = YES;
        self.contentImg.backgroundColor = RANDOM_COLOR;
        [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left);
            make.height.mas_equalTo(70);
            make.width.mas_equalTo(94);
            
        }];
        
        //内容
        self.textLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor
                                                 ]
                                           font:FONT(15)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.textLbl];
        self.textLbl.numberOfLines = 2;
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentImg.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(17.5);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor
                                                ]
                                          font:FONT(10)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.timeLbl];
    
        
        //阅读量
        self.readNumLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor
                                                ]
                                          font:FONT(10)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.readNumLbl];
        
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLbl.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            make.right.lessThanOrEqualTo(self.readNumLbl.mas_left);
            
        }];
        
        [self.readNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.greaterThanOrEqualTo(self.timeLbl.mas_right);
            make.bottom.equalTo(self.timeLbl.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
    }
    return self;
}

- (void)setArticleModel:(CSWArticleModel *)articleModel {

    _articleModel = articleModel;
    
    if (_articleModel.picArr.count > 0 ) {
        
        [self.contentImg sd_setImageWithURL:[NSURL URLWithString:[_articleModel.picArr[0] convertThumbnailImageUrl]] placeholderImage:nil];
        self.contentImg.hidden = NO;
        [self.contentImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(94);
        }];
   

        [self.textLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentImg.mas_right).offset(10);
     
        }];
        
    } else {
    
        [self.textLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentImg.mas_right);
            
        }];
        [self.contentImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.01);
        }];    }
    
    
    //---//
    
    //内容
    self.textLbl.text = _articleModel.title ? : _articleModel.content;
    
    //时间
    self.timeLbl.text = [_articleModel.publishDatetime convertToTimelineDate];
    
    
    
    static  NSAttributedString *attr;
    attr   = attr ? : [NSAttributedString convertImg:[UIImage imageNamed:@"阅读量"] bounds:CGRectMake(0, -1, 15, 8)];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_articleModel.sumRead]]];
    self.readNumLbl.attributedText = mutableAttr;

}


//- (void)data {
//
//    self.contentImg.image = [UIImage imageNamed:@"二手"];
//    self.textLbl.text = @"简单来说，就是设置显示电池电量、时间、网络部分标示的颜色， 这里只能设置两种颜色";
//    self.timeLbl.text = @"2019-32-32";
//    
//    static  NSAttributedString *attr;
//    attr   = attr ? : [NSAttributedString convertImg:[UIImage imageNamed:@"阅读量"] bounds:CGRectMake(0, -1, 15, 8)];
//    
//    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
//    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 1000"] ];
//    self.readNumLbl.attributedText = mutableAttr;
//
//}

+ (NSString *)reuseId {
    
    return @"tlArticleCellId";
    
}
@end
