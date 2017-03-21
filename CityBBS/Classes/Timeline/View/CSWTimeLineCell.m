//
//  CSWTimeLineCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWTimeLineCell.h"

#import "MLLinkLabel.h"
#import "PYPhotosView.h"
#import "CSWTimeLineToolBar.h"
#import "CSWClickLinkLabel.h"

@interface CSWTimeLineCell()<MLLinkLabelDelegate>

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *plateLbl;

//--//
@property (nonatomic, strong) UILabel *titleLbl; //标题lbl
@property (nonatomic, strong) MLLinkLabel *contentLbl; //内容lbl
@property (nonatomic, strong) PYPhotosView *photosView; //内容lbl

@property (nonatomic, strong) CSWTimeLineToolBar *toolBar;

//底部评论背景
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLbl;
@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, strong) UIButton *lookMoreCommentBtn;

@end


@implementation CSWTimeLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.photoImageView];
        self.photoImageView.layer.cornerRadius = 25;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.backgroundColor = [UIColor orangeColor];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.nameLbl];
        
        //来自板块
        self.plateLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.plateLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_top).offset(10);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.plateLbl.mas_left);
            
        }];
        
        [self.plateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.greaterThanOrEqualTo(self.nameLbl.mas_right);
            make.top.equalTo(self.nameLbl.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(10)
                                      textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
            make.right.lessThanOrEqualTo(self.contentView.mas_right);
            
        }];
        
        CSWLayoutHelper *layout = [CSWLayoutHelper helper];
        
        //帖子标题
        CGFloat w = SCREEN_WIDTH - (self.photoImageView.xx + 10) - 15;
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(self.photoImageView.xx + 10, self.photoImageView.yy, w , 50)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:layout.titleFont
                                      textColor:[UIColor themeColor]];
        self.titleLbl.numberOfLines = 0;
        [self.contentView addSubview:self.titleLbl];
        
        //内容
        self.contentLbl = [[MLLinkLabel alloc] initWithFrame:CGRectMake(self.titleLbl.x, self.titleLbl.yy + 7, w, 50)];
        self.contentLbl.dataDetectorTypes = MLDataDetectorTypeAll;
        self.contentLbl.font = layout.contentFont;
        self.contentLbl.delegate = self;
        self.contentLbl.textColor = [UIColor textColor];
        self.contentLbl.numberOfLines = 0;
        [self.contentView addSubview:self.contentLbl];
        
        //图片浏览--可能无
        self.photosView = [[PYPhotosView  alloc] init];
        [self.contentView addSubview:self.photosView];
        self.photosView.photoMargin = layout.photoMargin;
        self.photosView.photoHeight = layout.photoWidth;
        self.photosView.photoWidth = layout.photoWidth;
       
        //---//分享 --- 点赞 -- 评论
        self.toolBar = [[CSWTimeLineToolBar alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.toolBar];
        
        
        //点赞和评论
        self.arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowImageView];
        self.arrowImageView.image = [UIImage imageNamed:@"timeline_article_arrow"];
        
        self.bottomBgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomBgView];
        self.bottomBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.bottomBgView.layer.cornerRadius = 8;
        self.bottomBgView.layer.masksToBounds = YES;
        
        //
        self.likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_line_dz"]];
        self.likeImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.bottomBgView addSubview:self.likeImageView];
        [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView.mas_left).offset(layout.commentMargin);
            make.centerY.equalTo(self.bottomBgView.mas_top).offset(15);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(layout.likeHeight);

        }];
        
        //点赞人数
        self.likeCountLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]
                                               font:layout.likeFont
                                          textColor:[UIColor textColor]];

        self.likeCountLbl.numberOfLines = 1;
        [self.bottomBgView addSubview:self.likeCountLbl];
        
        //更多点赞列表
        self.likeLabel = [[MLLinkLabel alloc] initWithFrame:CGRectZero];
        self.likeLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        self.likeLabel.font = layout.likeFont;
        self.likeLabel.delegate = self;
        self.likeLabel.textAlignment = NSTextAlignmentLeft;
//        self.likeLabel.textColor = [UIColor colorWithHexString:@"#7d0000"];
        self.likeLabel.textColor = [UIColor textColor];

        self.likeLabel.numberOfLines = 1;
        [self.bottomBgView addSubview:self.likeLabel];
        
        
        [self.likeCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.likeImageView.mas_right).offset(8);
            make.top.equalTo(self.bottomBgView.mas_top);
            make.height.mas_equalTo(layout.likeHeight);
//            make.right.lessThanOrEqualTo();
            make.right.lessThanOrEqualTo(self.likeLabel.mas_left);
        }];
        
 
        [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBgView.mas_top);
            make.height.equalTo(self.likeCountLbl.mas_height);
            make.left.equalTo(self.likeCountLbl.mas_right).offset(9);
            
            make.right.lessThanOrEqualTo(self.bottomBgView.mas_right).offset(-layout.commentMargin);
//            make.right.equalTo(self.bottomBgView.mas_right).offset(-layout.commentMargin);
            
        }];
        
        //线
        self.line = [CALayer layer];
        self.line.backgroundColor = [UIColor whiteColor].CGColor;
        [self.bottomBgView.layer addSublayer:self.line];
        
        //更多评论
        self.lookMoreCommentBtn = [[UIButton alloc] init];
       [self.lookMoreCommentBtn setTitle:@"查看全部评论>>" forState:UIControlStateNormal];
        self.lookMoreCommentBtn.titleLabel.font = layout.commentFont;
        [self.lookMoreCommentBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.lookMoreCommentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bottomBgView addSubview:self.lookMoreCommentBtn];
        
        //评论
        //-----底线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;

}


#pragma mark- linkLableDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel {


}

- (void)setLayoutItem:(CSWLayoutItem *)layoutItem {

    _layoutItem = layoutItem;
    self.photoImageView.image = [UIImage new];
    self.nameLbl.text= @"天下";
    
    NSMutableAttributedString *plateStr = [[NSMutableAttributedString alloc] initWithString:@"来自 游戏模块" ];
    [plateStr addAttribute:NSForegroundColorAttributeName value:[UIColor textColor] range:NSMakeRange(0, 2)];
    
    self.plateLbl.attributedText = plateStr;
    self.timeLbl.text = @"一小时前";
    
    //
    self.titleLbl.frame = _layoutItem.titleFrame;
    self.contentLbl.frame = _layoutItem.contentFrame;
    
    self.titleLbl.text = _layoutItem.article.title;
    self.contentLbl.text = _layoutItem.article.content;
    self.contentLbl.attributedText = _layoutItem.contentAttributedString;
    
    
    //图片浏览
    self.photosView.frame = _layoutItem.phototsFrame;
    self.photosView.thumbnailUrls = _layoutItem.article.photos;
    self.photosView.originalUrls = _layoutItem.article.photos;
    
    //背景
    self.toolBar.frame = _layoutItem.toolBarFrame;
    self.arrowImageView.frame = _layoutItem.arrowFrame;
    self.bottomBgView.frame = _layoutItem.bottomBgFrame;
    
    [self.bottomBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[CSWClickLinkLabel class]]) {
                
                [obj removeFromSuperview];

            }
    }];
    
    //点赞
    if (_layoutItem.isHasLike) { //有点赞
        
        self.line.frame = _layoutItem.lineFrame;
        self.likeCountLbl.text = @"2121";
        self.likeLabel.attributedText = _layoutItem.likeAttributedString;
        
    } else {
    
        self.likeLabel.hidden = YES;
        self.line.hidden = YES;
    }
    
    //评论
    [_layoutItem.commentFrames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         CSWClickLinkLabel *linkLable = [[CSWClickLinkLabel alloc] initWithFrame:[obj CGRectValue]];
        linkLable.textColor = [UIColor textColor];
        linkLable.font = [CSWLayoutHelper helper].commentFont;
        linkLable.numberOfLines = 0;
        linkLable.textColor = [UIColor textColor];
//        linkLable.backgroundColor = idx%2 ? [UIColor orangeColor] : [UIColor cyanColor];
        linkLable.attributedText = _layoutItem.attributedComments[idx];
        [self.bottomBgView addSubview:linkLable];
    }];
    
    if (_layoutItem.isShowLookMoreCommentBtn) {
        
        self.lookMoreCommentBtn.hidden = NO;
        self.lookMoreCommentBtn.frame = _layoutItem.lookMoreCommentBtnFrame;
    } else {
        
        self.lookMoreCommentBtn.hidden = YES;

    }
    
    
    //点赞和评论
    
//    MLLinkLabel *linkLable = [[MLLinkLabel alloc] initWithFrame:CGRectMake(100, self.arrowImageView.yy, 300, 50)];
//    [self.contentView addSubview:linkLable];
//    
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"link" attributes:@{
//                                                                                               NSLinkAttributeName : @"userId",
//                                                                                               NSForegroundColorAttributeName : [UIColor orangeColor]
//                                                                                              }];
//    
//    linkLable.attributedText = attr;
//    
//    [linkLable setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        
//    }];
    
    
    
}


@end