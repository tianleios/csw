//
//  CSWCommentModel.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentModel.h"

@implementation CSWCommentModel


- (instancetype)initWithCommentUserId:(NSString *)commentUserId
                  commentUserNickname:(NSString *)commentUserNickname
                       commentContent:(NSString *)commentContent
            parentCommentUserNickname:(NSString *)parentCommentUserNickname commentDatetime:(NSString *)commentDatetime {

    if (self= [super init]) {
        
        self.commer = commentUserId;
        self.nickname = commentUserNickname;
        self.content = commentContent;
        
        self.parentComment = [NSMutableDictionary dictionary];
        self.parentComment[@"nickname"] = parentCommentUserNickname;
        self.commDatetime = commentDatetime;
        
    }
    
    return self;

}
- (NSString *)commentUserId {

    return self.commer;
}

- (NSString *)commentUserNickname {

    if (self.nickname) {
        
        return self.nickname;

    } else {
        
        return @"未知用户";

    
    }

}

- (NSString *)parentCommentUserNickname {

    if (self.parentComment && self.parentComment[@"nickname"]) {
        return self.parentComment[@"nickname"];
    }
    
    return nil;
    
}


- (NSString *)parentCommentUserId {

    if (self.parentComment && self.parentComment[@"commer"]) {
        return self.parentComment[@"commer"];
    }
    
    return nil;

}

- (NSString *)commentContent{

    return self.content;
}

- (NSString *)commentDatetime {

    return self.commDatetime;
}

@end
