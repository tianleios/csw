//
//  CSWSendCommentVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "CSWCommentModel.h"

typedef NS_ENUM(NSUInteger, CSWSendCommentActionType) {
    
    CSWSendCommentActionTypeToArticle = 0,
    
    CSWSendCommentActionTypeToComment = 1
    
};

@interface CSWSendCommentVC : TLBaseVC

@property (nonatomic, assign) CSWSendCommentActionType type;

//发送对象的Code
@property (nonatomic, copy) NSString *toObjCode;

//对帖子发就没有
@property (nonatomic, copy) NSString *toObjNickName;


@property (nonatomic, copy) void(^commentSuccess)(CSWCommentModel *commentModel);

@end
