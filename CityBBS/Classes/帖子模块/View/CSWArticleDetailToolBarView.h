//
//  CSWArticleDetailToolBarView.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSWArticleDetailToolBarView;

typedef NS_ENUM(NSUInteger, CSWArticleDetailToolBarActionType) {
    
    CSWArticleDetailToolBarActionTypeSendCompose = 0,
    CSWArticleDetailToolBarActionTypeDelete,
    CSWArticleDetailToolBarActionTypeDZ,
    CSWArticleDetailToolBarActionTypeCollection, //收藏
    CSWArticleDetailToolBarActionTypeCancleCollection, //收藏
    CSWArticleDetailToolBarActionTypeReport //举报

};

@protocol ArticleDetailToolBarViewDelegate <NSObject>

- (void)didSelectedAction:(CSWArticleDetailToolBarView *)toolBarView action:(CSWArticleDetailToolBarActionType) actionType;

@end


@interface CSWArticleDetailToolBarView : UIView

@property (nonatomic, weak) id <ArticleDetailToolBarViewDelegate> delegate;

//是否收藏 yes 已经收藏，NO还未收藏
@property (nonatomic, assign) BOOL isCollection;

//当期那登录用户的帖子详情
- (void)isCurrentUserArticle:(BOOL)isCurrentUser;

//点赞操作
- (void)dzSuccess; //点赞成功
- (void)dzFailure; //点赞失败
- (void)unDz; //为点赞

@end




