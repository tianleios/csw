//
//  CSWLayoutItem.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWLayoutItem.h"
#import "TLEmoticonHelper.h"
#import "MLLinkLabel.h"

#define CONST_TOP_HEIGHT 65

static MLLinkLabel * kProtypeLabel() {
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = FONT(14);
        _protypeLabel.numberOfLines = 0;
        
//        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//        _protypeLabel.lineHeightMultiple = 1.1f;
    });
    return _protypeLabel;
}


@implementation CSWLayoutItem

- (void)setArticle:(CSWArticleModel *)article {

    _article = article;
    
    CSWLayoutHelper *layoutHelper = [CSWLayoutHelper helper];
    CGFloat leftMargin = [CSWLayoutHelper helper].contentLeftMargin;
    CGFloat contentW = [CSWLayoutHelper helper].contentWidth;
    //1.标题
    CGSize titleSize = [_article.title calculateStringSize:CGSizeMake(contentW, MAXFLOAT) font:[CSWLayoutHelper helper].titleFont];
    self.titleFrame =CGRectMake(leftMargin, CONST_TOP_HEIGHT, titleSize.width, titleSize.height);
    
    //2.内容-- 先给值才能计算出真正的高度
//    CGSize contentSize = [_article.content calculateStringSize:CGSizeMake(contentW, MAXFLOAT) font:[CSWLayoutHelper helper].contentFont];
    self.contentAttributedString = [TLEmoticonHelper convertEmoticonStrToAttributedString:_article.content];
    MLLinkLabel *testLabel = kProtypeLabel();
    testLabel.attributedText = self.contentAttributedString;
    CGSize contenSize = [testLabel sizeThatFits:CGSizeMake(contentW, MAXFLOAT)];
    self.contentFrame = CGRectMake(leftMargin, CGRectGetMaxY(self.titleFrame) + 5, contenSize.width, contenSize.height);
    
    //3.图片
    NSInteger hang = 0;
    if (self.article.photos.count >= 7) {
        hang = 3;
    } else if (self.article.photos.count >= 4) {
        hang = 2;
    } else if (self.article.photos.count >= 1) {
    
        hang = 1;
    }

    CGFloat photosHeight = [CSWLayoutHelper helper].photoWidth * hang + [CSWLayoutHelper helper].photoMargin * (hang - 1);
    self.phototsFrame = CGRectMake(leftMargin, CGRectGetMaxY(self.contentFrame) + 8, contentW, photosHeight);
    
    //4.工具栏
    self.toolBarFrame = CGRectMake(leftMargin, CGRectGetMaxY(self.phototsFrame) + 15, contentW, 20);
    
    //5.底部背景,根据内容决定高度
    self.arrowFrame = CGRectMake(leftMargin + 18, CGRectGetMaxY(self.toolBarFrame) + 10, 16, 8);

    
    
    //6.点赞和评论
    
    //6.1点赞 最多展示--5类--个人
    if (_article.dzArray.count > 0) { //有评论
      
        self.isHasLike = YES;
        self.likeAttributedString = [[NSMutableAttributedString alloc] init];
        [_article.dzArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:obj attributes:@{
                                                                                                      NSLinkAttributeName : obj
                                                                                                      }];
            [self.likeAttributedString appendAttributedString:attrStr];
            [self.likeAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"、"]];

            if (idx >= 5) {
                *stop  = YES;
            }
            
        }];

        self.lineFrame = CGRectMake(0, 30, contentW, 1);
        
    } else { //无评论
    
        self.isHasLike = NO;
        
    }

    
    //6.2 评论 最多战死
    //6.2.1单评论
    //6.2.2相互平路
    self.commentFrames = [NSMutableArray new];
    self.attributedComments = [NSMutableArray new];
    
    __block CGFloat lastCommentTop;
    if (self.isHasLike) {
        
        lastCommentTop = CGRectGetMaxY(self.lineFrame) + layoutHelper.commentMargin;
        
    } else {
    
        lastCommentTop = layoutHelper.commentMargin;

    }
    
    
    [_article.comments enumerateObjectsUsingBlock:^(CSWCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSMutableAttributedString *singleCommentAttrStr = nil;
        if (idx >= 5) {
            *stop = YES;
        }
        
        if (obj.reUserId) { //有回复
            
            singleCommentAttrStr  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复 %@: %@",obj.userId,obj.reUserId,obj.reCommentText] ];
            
            [singleCommentAttrStr addAttributes:@{
                                                  NSLinkAttributeName : obj.userId
                                                  } range:NSMakeRange(0, obj.userId.length)];
            
            [singleCommentAttrStr addAttributes:@{
                                                  NSLinkAttributeName : obj.reUserId
                                                  } range:NSMakeRange(obj.userId.length + 2 + 2, obj.reUserId.length)];
            
         
            
        } else {//无回复
            
            singleCommentAttrStr  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",obj.userId,obj.commentText]];
            
            [singleCommentAttrStr addAttributes:@{
                                                  NSLinkAttributeName : obj.userId
                                                  } range:NSMakeRange(0, obj.userId.length)];
           
        
        }
       
        //添加评论
        [self.attributedComments addObject: singleCommentAttrStr];
        
        //添加评论的frame
        CGSize size = [singleCommentAttrStr.string calculateStringSize:CGSizeMake(contentW - 2*layoutHelper.commentMargin, MAXFLOAT) font:layoutHelper.commentFont];
        
        CGRect commentFrame = CGRectMake(layoutHelper.commentMargin, lastCommentTop, size.width, size.height);
        [self.commentFrames addObject:[NSValue valueWithCGRect:commentFrame]];
        lastCommentTop = lastCommentTop +  size.height + layoutHelper.commentMargin;
        
    }];
    
    
    
    if (_article.comments.count > 5) {
        
        self.isShowLookMoreCommentBtn = YES;
        self.lookMoreCommentBtnFrame = CGRectMake(layoutHelper.commentMargin, lastCommentTop, 150, [FONT(14) lineHeight]);
        //根据内容决定高度
        self.bottomBgFrame = CGRectMake(leftMargin,CGRectGetMaxY(self.arrowFrame), contentW, CGRectGetMaxY(self.lookMoreCommentBtnFrame) + layoutHelper.commentTopMargin);
        

    } else {
        
        self.isShowLookMoreCommentBtn = NO;
        //根据内容决定高度
        self.bottomBgFrame = CGRectMake(leftMargin,CGRectGetMaxY(self.arrowFrame), contentW, lastCommentTop);
        
        
    }
    
    //cell高度
    self.cellHeight = CGRectGetMaxY(self.bottomBgFrame) + 10;

}
@end
