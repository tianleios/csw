//
//  CSWCommentAndLikeView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentAndLikeView.h"

#import "CSWLinkLabel.h"

@interface CSWCommentAndLikeView()

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLbl;

@property (nonatomic, strong) CSWLinkLabel *likeLabel;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, strong) UIButton *lookMoreCommentBtn;


@property (nonatomic, strong) NSMutableArray <CSWLinkLabel *>*commentLblRooms;

@end

@implementation CSWCommentAndLikeView

- (NSMutableArray<CSWLinkLabel *> *)commentLblRooms {

    if (!_commentLblRooms) {
        
        _commentLblRooms = [[NSMutableArray alloc] init];
    }
    return _commentLblRooms;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        
        CSWLayoutHelper *layout = [CSWLayoutHelper helper];

        
        self.likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_line_dz"]];
        self.likeImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.likeImageView];
        [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(layout.commentMargin);
            make.centerY.equalTo(self.mas_top).offset(15);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(layout.likeHeight);
            
        }];
        
        //点赞人数
        self.likeCountLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:self.backgroundColor
                                               font:layout.likeFont
                                          textColor:[UIColor textColor]];
        
        self.likeCountLbl.numberOfLines = 1;
        [self addSubview:self.likeCountLbl];
        
        //更多点赞列表
        self.likeLabel = [[CSWLinkLabel alloc] initWithFrame:CGRectZero];
        self.likeLabel.font = layout.likeFont;
        self.likeLabel.textAlignment = NSTextAlignmentLeft;
        self.likeLabel.backgroundColor = self.backgroundColor;
        //        self.likeLabel.textColor = [UIColor colorWithHexString:@"#7d0000"];
        self.likeLabel.textColor = [UIColor textColor];
        
        self.likeLabel.numberOfLines = 1;
        [self addSubview:self.likeLabel];
        
        
        [self.likeCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.likeImageView.mas_right).offset(8);
            make.height.mas_equalTo(layout.likeHeight);
            //            make.right.lessThanOrEqualTo();
//            make.right.lessThanOrEqualTo(self.likeLabel.mas_left).priorityHigh();
        }];
        
        
        [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.likeCountLbl.mas_right).offset(9);
            make.height.mas_equalTo(layout.likeHeight);
            make.right.lessThanOrEqualTo(self.mas_right);;
            
        }];
        
        //线
        self.line = [CALayer layer];
        self.line.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.line];
        
        //更多评论
        self.lookMoreCommentBtn = [[UIButton alloc] init];
        [self.lookMoreCommentBtn setTitle:@"查看全部评论>>" forState:UIControlStateNormal];
        self.lookMoreCommentBtn.titleLabel.font = layout.commentFont;
        [self.lookMoreCommentBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.lookMoreCommentBtn.backgroundColor = self.backgroundColor;
        self.lookMoreCommentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:self.lookMoreCommentBtn];
        
    }
    return self;
}

- (void)setLayoutItem:(CSWLayoutItem *)layoutItem {

    _layoutItem = layoutItem;
    

    
    //
    self.likeImageView.hidden = !_layoutItem.isHasLike;
    self.likeCountLbl.hidden = !_layoutItem.isHasLike;
    self.likeLabel.hidden = !_layoutItem.isHasLike;
    self.line.hidden = !_layoutItem.isHasLike;
    
    //
    if (_layoutItem.isHasLike) {
        
        //有点赞
        self.line.frame = _layoutItem.lineFrame;
        self.likeCountLbl.text = [NSString stringWithFormat:@"%@",_layoutItem.article.sumLike];
        self.likeLabel.attributedText = _layoutItem.likeAttributedString;
        
    }
    
    
    if (_layoutItem.isHasComment) {//----------------------有评论--------------------------//
        
        
        NSInteger currentCount = self.commentLblRooms.count;
        NSInteger targetCount = layoutItem.commentFrames.count;
        
        
        //先移除，视图
        [self.commentLblRooms enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[CSWLinkLabel class]]) {
                
                [obj removeFromSuperview];
                
            }
        }];
        
        
        //lbl复用
        if (targetCount > currentCount ) {
            
            //创建,差值
            for (NSInteger i = 0; i < targetCount - currentCount; i ++) {
                
                CSWLinkLabel *linkLable = [[CSWLinkLabel alloc] init];
                linkLable.textColor = [UIColor textColor];
                linkLable.font = [CSWLayoutHelper helper].commentFont;
                linkLable.numberOfLines = 0;
                linkLable.backgroundColor = self.backgroundColor;
                linkLable.textColor = [UIColor textColor];
                [self.commentLblRooms addObject:linkLable];
            }
            
        }
        
        //评论, 创建Lbl -- 把lbl存储起来
        [_layoutItem.commentFrames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CSWLinkLabel *linkLable = self.commentLblRooms[idx];
            linkLable.frame = [obj CGRectValue];
            linkLable.attributedText = _layoutItem.attributedComments[idx];
            linkLable.hidden = NO;
            [self addSubview:linkLable];
            
        }];
        
        
        
        if (_layoutItem.isShowLookMoreCommentBtn) {
            
            self.lookMoreCommentBtn.hidden = NO;
            self.lookMoreCommentBtn.frame = _layoutItem.lookMoreCommentBtnFrame;
        } else {
            
            self.lookMoreCommentBtn.hidden = YES;
            
        }
        
    } else { //-----------------------无评论--------------------------//
    
        [self.commentLblRooms enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[CSWLinkLabel class]]) {
                
                obj.hidden = YES;
                
            }
        }];
    
    }
 

}
@end
