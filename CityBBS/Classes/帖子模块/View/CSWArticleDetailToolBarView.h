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
    CSWArticleDetailToolBarActionTypeDZ,
    CSWArticleDetailToolBarActionTypeCollection,
    CSWArticleDetailToolBarActionTypeReport,

};

@protocol ArticleDetailToolBarViewDelegate <NSObject>

- (void)didSelectedAction:(CSWArticleDetailToolBarView *)toolBarView action:(CSWArticleDetailToolBarActionType) actionType;

@end


@interface CSWArticleDetailToolBarView : UIView

@property (nonatomic, weak) id <ArticleDetailToolBarViewDelegate> delegate;

- (void)dzSuccess;
- (void)dzFailure;

@end




