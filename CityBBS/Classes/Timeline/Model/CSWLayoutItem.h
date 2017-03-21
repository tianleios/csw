//
//  CSWLayoutItem.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//  负责布局，和 --- 数据转换

#import <Foundation/Foundation.h>
#import "CSWArticleModel.h"
#import "CSWLayoutHelper.h"

@interface CSWLayoutItem : NSObject

@property (nonatomic, assign) CGRect titleFrame; //帖子标题

@property (nonatomic, assign) CGRect contentFrame; //帖子内容

@property (nonatomic, assign) CGRect phototsFrame; //图片浏览

@property (nonatomic, assign) CGRect toolBarFrame; //工具栏


/**
 点赞评论相关
 */
@property (nonatomic, assign) CGRect arrowFrame; //点赞聊天背景
@property (nonatomic, assign) CGRect bottomBgFrame; //点赞聊天背景

@property (nonatomic, assign) BOOL isHasLike;
//@property (nonatomic, assign) CGRect likeFrame; //点赞lbl
@property (nonatomic, assign) CGRect lineFrame; //下线

@property (nonatomic, assign) BOOL isShowLookMoreCommentBtn;
@property (nonatomic, assign) CGRect lookMoreCommentBtnFrame; //查看更多评论


@property (nonatomic, strong) NSMutableAttributedString *likeAttributedString;

//评论的frame
@property (nonatomic, strong) NSMutableArray <NSValue *> *commentFrames;
@property (nonatomic, strong) NSMutableArray <NSAttributedString *> *attributedComments;



@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) CSWArticleModel *article;
@property (nonatomic, strong) NSAttributedString *contentAttributedString;

@end
