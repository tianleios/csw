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
#import "CSWCommentAndLikeView.h"
#import "CSWUserPhotoView.h"
#import "CSWLinkLabel.h"

@interface CSWTimeLineCell()

@property (nonatomic, strong) CSWUserPhotoView *photoImageView;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *plateLbl;

//--//
@property (nonatomic, strong) UILabel *titleLbl; //标题lbl
@property (nonatomic, strong) CSWLinkLabel *contentLbl; //内容lbl
@property (nonatomic, strong) PYPhotosView *photosView; //内容lbl

//工具栏
@property (nonatomic, strong) CSWTimeLineToolBar *toolBar;

//底部评论背景 + 箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) CSWCommentAndLikeView *commentAndLikeView;

@end


@implementation CSWTimeLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.photoImageView = [[CSWUserPhotoView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.photoImageView];
//        self.photoImageView.layer.cornerRadius = 25;
//        self.photoImageView.layer.masksToBounds = YES;
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
        
        //关注按钮,详情显示关注按钮，外部列表显示来自哪个版块
        self.focusBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.focusBtn];
        self.focusBtn.layer.cornerRadius = 4;
        self.focusBtn.layer.borderColor = [UIColor themeColor].CGColor;
        self.focusBtn.layer.borderWidth = 1;
        [self.focusBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.focusBtn.titleLabel.font = FONT(13);
        //
        
        
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
        
        //--//
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
        
        [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(25);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.photoImageView.mas_centerY);
            
        }];
    
        
        
//--------头部以下-----------//
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
        self.contentLbl = [[CSWLinkLabel alloc] initWithFrame:CGRectMake(self.titleLbl.x, self.titleLbl.yy + 7, w, 50)];
        self.contentLbl.font = layout.contentFont;
        self.contentLbl.textColor = [UIColor textColor];
        self.contentLbl.numberOfLines = 0;
        self.contentLbl.lineHeightMultiple = 1.2;
        [self.contentView addSubview:self.contentLbl];
        self.contentLbl.backgroundColor = [UIColor whiteColor];
        
        //图片浏览--可能无
        self.photosView = [[PYPhotosView  alloc] init];
        [self.contentView addSubview:self.photosView];
        self.photosView.photoMargin = layout.photoMargin;
        self.photosView.photoHeight = layout.photoWidth;
        self.photosView.photoWidth = layout.photoWidth;
       
        //分享 --- 点赞 -- 评论
        self.toolBar = [[CSWTimeLineToolBar alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.toolBar];
        
        
        //点赞和评论
        self.arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowImageView];
        self.arrowImageView.image = [UIImage imageNamed:@"timeline_article_arrow"];

        self.commentAndLikeView = [[CSWCommentAndLikeView alloc] init];
        [self.contentView addSubview:self.commentAndLikeView];
        
        //底线
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
    
    //--//
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_layoutItem.article.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    self.nameLbl.text= _layoutItem.article.nickname;
    self.photoImageView.userId = _layoutItem.article.publisher;
    
    //是详情，还是外部列表
    if (_layoutItem.type == CSWArticleLayoutTypeArticleDetail) {
        
        self.focusBtn.hidden = NO;
        self.plateLbl.hidden = YES;
        
    } else  {
        
        self.focusBtn.hidden = YES;
        self.plateLbl.hidden = NO;

    }
    
    
    //--//
    NSMutableAttributedString *plateStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",_layoutItem.article.plateName]];
    [plateStr addAttribute:NSForegroundColorAttributeName value:[UIColor textColor] range:NSMakeRange(0, 2)];
    self.plateLbl.attributedText = plateStr;
    self.timeLbl.text = [_layoutItem.article.publishDatetime convertToDetailDate];
    
    //1.title
    self.titleLbl.frame = _layoutItem.titleFrame;
    self.titleLbl.text = _layoutItem.article.title;

    //2.cocntent
    self.contentLbl.frame = _layoutItem.contentFrame;
    self.contentLbl.attributedText = _layoutItem.contentAttributedString;
    
    
    //3.图片浏览
    if (/*有图*/_layoutItem.isHasPhoto) {
        
        self.photosView.hidden = NO;
        self.photosView.frame = _layoutItem.phototsFrame;
        self.photosView.thumbnailUrls = _layoutItem.article.thumbnailUrls;
        self.photosView.originalUrls = _layoutItem.article.originalUrls;
        
    } else {

        
        self.photosView.hidden = YES;
    
    }
    
    //
    if (_layoutItem.type == CSWArticleLayoutTypeArticleDetail) {
        self.toolBar.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.commentAndLikeView.hidden = YES;
        return;
    }
    
    self.toolBar.hidden = NO;
    self.arrowImageView.hidden = NO;
    self.commentAndLikeView.hidden = NO;
    
    //工具栏----重要节点，分割作用
    self.toolBar.frame = _layoutItem.toolBarFrame;
    self.toolBar.layoutItem = _layoutItem;
    
    //先整体判断隐藏与否
    self.arrowImageView.hidden = !_layoutItem.isHasComment && !_layoutItem.isHasLike;
    self.commentAndLikeView.hidden = !_layoutItem.isHasComment && !_layoutItem.isHasLike;
    
    if (!_layoutItem.isHasLike && !_layoutItem.isHasComment) {
        
        return;
    }
    

    self.arrowImageView.frame = _layoutItem.arrowFrame;
    self.commentAndLikeView.frame= _layoutItem.bottomBgFrame;
    self.commentAndLikeView.layoutItem = _layoutItem;
    
}

- (void)focusing {

    [self.focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.focusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
    }];
}


- (void)unFocus {

    [self.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [self.focusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
    }];

}


@end
