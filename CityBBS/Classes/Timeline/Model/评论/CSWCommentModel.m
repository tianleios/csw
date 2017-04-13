//
//  CSWCommentModel.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentModel.h"

@implementation CSWCommentModel

- (NSString *)commentUserId {

    return self.commer;
}

- (NSString *)commentUserNickname {

    return self.nickname;

}

- (NSString *)commentContent{

    return self.content;
}

- (NSString *)commentDatetime {

    return self.commDatetime;
}

@end
