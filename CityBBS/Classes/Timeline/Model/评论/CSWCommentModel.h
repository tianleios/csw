//
//  CSWCommentModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWCommentModel : TLBaseModel
//B 已发布 C2 被举报待审批 D 审批通过 E 待回收 F 被过滤

@property (nonatomic, copy, readonly) NSString *commentUserId;
@property (nonatomic, copy, readonly) NSString *commentUserNickname;
@property (nonatomic, copy, readonly) NSString *commentContent;

@property (nonatomic, copy, readonly) NSString *replyCommentUserId;
@property (nonatomic, copy, readonly) NSString *replyCommentUserNickname;

@property (nonatomic, copy, readonly) NSString *commentDatetime;


@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *status;

//评论时间
@property (nonatomic, copy) NSString *commDatetime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commer;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *nickname;


//@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, strong) NSString *commentText;
//
////回复人
//@property (nonatomic, copy) NSString *reUserId;
//@property (nonatomic, strong) NSString *reCommentText;

@end

//code = PL20170410006570983;
//commDatetime = "Apr 10, 2017 6:57:09 PM";
//commer = U2017033120533194265;
//content = asfd;
//loginName = 18868824532CSW18868824532;
//nickname = "\U5434\U8054\U8bf7";
//parentCode = TZ20170410005562924;
//photo = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLCgmQKCoYiaz04XxcqYVRkFU6fEehlVW4FauvjSV9U4mVRT6LzPBA7yHbqGkbKhW1gq0TZ5CBnbB3w/0";
//postCode = TZ20170410005562924;
//status = B;
