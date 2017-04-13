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
        _protypeLabel.font = [CSWLayoutHelper helper].contentFont;
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
    CGFloat photoCount = _article.picArr.count;
    self.isHasPhoto = photoCount > 0;
    if (photoCount > 0) {
        //有图
        if (photoCount >= 7) {
            hang = 3;
        } else if (photoCount >= 4) {
            hang = 2;
        } else if (photoCount >= 1) {
            
            hang = 1;
        }
        
        CGFloat photosHeight = [CSWLayoutHelper helper].photoWidth * hang + [CSWLayoutHelper helper].photoMargin * (hang - 1);
        self.phototsFrame = CGRectMake(leftMargin, CGRectGetMaxY(self.contentFrame) + 8, contentW, photosHeight);

    }

    //4.工具栏
    CGFloat toolBarY = self.isHasPhoto ? ( CGRectGetMaxY(self.phototsFrame) + 10) : (CGRectGetMaxY(self.contentFrame) + 10)  ;
    self.toolBarFrame = CGRectMake(leftMargin, toolBarY, contentW, 20);
    
    //5.底部背景,根据内容决定高度
    self.isHasLike = _article.likeList.count > 0;
    self.isHasComment = _article.commentList.count > 0;
    if (!self.isHasLike && !self.isHasComment ) {
        //无评论 , 无点赞
        self.cellHeight = CGRectGetMaxY(self.toolBarFrame) + 10;
        return;
    }
    
    //箭头
    self.arrowFrame = CGRectMake(leftMargin + 18, CGRectGetMaxY(self.toolBarFrame) + 10, 16, 8);

    
    //6.点赞
    //AA.有点赞，有评论
    //BB.有点赞，无评论
    //CC.无点赞，有评论
    if(self.isHasLike) {
    
        self.likeAttributedString = [[NSMutableAttributedString alloc] init];
        [_article.likeList enumerateObjectsUsingBlock:^(CSWLikeModel  *likeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:likeModel.nickname attributes:@{
                                                                                                      NSLinkAttributeName : likeModel.nickname
                                                                                                      }];
            [self.likeAttributedString appendAttributedString:attrStr];
            [self.likeAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"、"]];
            
            if (idx >= 5) {
                *stop  = YES;
            }
            
        }];
        
        //点赞高度固定30
        self.lineFrame = CGRectMake(0, 30, contentW, 1);
        
        if(self.isHasComment) {
        //AA.有点赞有评论

          CGFloat commentTop = CGRectGetMaxY(self.lineFrame) + layoutHelper.commentMargin;
         [self setCommentContentWithTop:commentTop leftMargin:leftMargin contetnW:contentW layoutHelper:layoutHelper];
            
        } else {
            
        //BB.有点赞无评论
            self.lineFrame = CGRectMake(0, 30, contentW, 0);
            self.bottomBgFrame = CGRectMake(leftMargin,CGRectGetMaxY(self.arrowFrame), contentW, 30);
             //cell高度
            self.cellHeight = CGRectGetMaxY(self.bottomBgFrame) + 10;
        
        }
        
        
        
    } else {//---------------------------CC.无点赞有评论--------------------------------//

        [self setCommentContentWithTop:layoutHelper.commentMargin leftMargin:leftMargin contetnW:contentW layoutHelper:layoutHelper];
        
    }
    
}

//--//
- (void)setCommentContentWithTop:(CGFloat)top leftMargin:(CGFloat)leftMargin contetnW:(CGFloat)contentW layoutHelper:(CSWLayoutHelper *)layoutHelper {


    self.commentFrames = [NSMutableArray new];
    self.attributedComments = [NSMutableArray new];
    
    __block CGFloat lastCommentTop = top;
//    lastCommentTop = layoutHelper.commentMargin;
    
    
    [_article.commentList enumerateObjectsUsingBlock:^(CSWCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 4) {
            *stop = YES;
        }
        
        //            if (obj.replyCommentUserId) { //双人回复
        //
        ////                singleCommentAttrStr  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复 %@: %@",obj.userId,obj.reUserId,obj.reCommentText] ];
        ////
        ////                [singleCommentAttrStr addAttributes:@{
        ////                                                      NSLinkAttributeName : obj.userId
        ////                                                      } range:NSMakeRange(0, obj.userId.length)];
        ////
        ////                [singleCommentAttrStr addAttributes:@{
        ////                                                      NSLinkAttributeName : obj.reUserId
        ////                                                      } range:NSMakeRange(obj.userId.length + 2 + 2, obj.reUserId.length)];
        //
        //
        //
        //            } else {//单评论
        //
        //                singleCommentAttrStr  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",obj.commentUserNickname,obj.commentContent]];
        //
        //                [singleCommentAttrStr addAttributes:@{
        //                                                      NSLinkAttributeName : obj.commentUserId
        //                                                      } range:NSMakeRange(0, obj.commentUserId.length)];
        //
        //
        //            }
        
        //显示但评论
        NSMutableAttributedString *singleCommentAttrStr = nil;
        NSString *commetnStr = [NSString stringWithFormat:@"%@: %@",obj.commentUserNickname,obj.commentContent];
        singleCommentAttrStr  = [[NSMutableAttributedString alloc] initWithString:commetnStr];
        
        [singleCommentAttrStr addAttributes:@{
                                              NSLinkAttributeName : obj.commentUserId
                                              } range:NSMakeRange(0, obj.commentUserNickname.length)];
        
        //添加评论
        [self.attributedComments addObject: singleCommentAttrStr];
        
        //添加评论的frame
        CGSize size = [singleCommentAttrStr.string calculateStringSize:CGSizeMake(contentW - 2*layoutHelper.commentMargin, MAXFLOAT) font:layoutHelper.commentFont];
        
        CGRect commentFrame = CGRectMake(layoutHelper.commentMargin, lastCommentTop, size.width, size.height);
        [self.commentFrames addObject:[NSValue valueWithCGRect:commentFrame]];
        
        //为下一次计算准备
        lastCommentTop = lastCommentTop +  size.height + layoutHelper.commentMargin;
        
    }];
    
    
    if (_article.commentList.count > 5) {
        
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
