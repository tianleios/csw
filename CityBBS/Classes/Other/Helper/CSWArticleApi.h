//
//  CSWArticleApi.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWArticleApi : UIView


/**
 举报帖子
 */
+ (void)reportArticleWithArticleCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure;

/**
 举报评论
 */
+ (void)reportCommentWithCommentCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure;

/**
 收藏帖子
 */
+ (void)collectionArticleWithCode:(NSString *)code
                         user:(NSString *)userId
                          success:(void(^)())success
                          failure:(void(^)())failure;

/**
 点赞帖子
 */
+ (void)dzArticleWithCode:(NSString *)code
                    user: (NSString *)userId
                  success:(void(^)())success
                  failure:(void(^)())failure;

/**
 打赏帖子
 */
+ (void)dsArticleWithCode:(NSString *)code
                     user:(NSString *)userId
                    money:(CGFloat)money
                  success:(void(^)())success
                  failure:(void(^)())failure;

@end
