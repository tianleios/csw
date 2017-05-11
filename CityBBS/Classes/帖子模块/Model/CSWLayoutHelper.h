//
//  CSWLayoutHelper.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSWLayoutHelper : NSObject

+ (instancetype)helper;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *contentFont;

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentLeftMargin;
@property (nonatomic, assign) CGFloat contentRightMargin;


//单个图片宽度
@property (nonatomic, assign) CGFloat photoWidth;
@property (nonatomic, assign) CGFloat photoMargin;

//评论和点赞
@property (nonatomic, strong) UIFont *likeFont;
@property (nonatomic, strong) UIFont *commentFont;
@property (nonatomic, assign) CGFloat likeMargin;
@property (nonatomic, assign) CGFloat likeHeight;

@property (nonatomic, assign) CGFloat commentMargin;

@property (nonatomic, assign) CGFloat commentTopMargin;





//+ (UIFont *)titleFont;
//+ (UIFont *)contentFont;
//
//+ (CGFloat)contentWidth; //标题和内容的最大宽度
//+ (CGFloat)contentLeftMargin; //内容的左边距
//
//+ (CGFloat)photoWidth;
//+ (CGFloat)photoMargin;

@end
