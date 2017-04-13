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

//构造数据
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, copy) NSString *commentUserNickname;
@property (nonatomic, copy) NSString *commentContent;

//互访数据
@property (nonatomic, copy) NSString *parentCommentUserId;
@property (nonatomic, copy) NSString *parentCommentUserNickname;
@property (nonatomic, copy) NSString *commentDatetime;



//原生数据
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *status;

//评论时间
@property (nonatomic, copy) NSString *commDatetime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commer;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSMutableDictionary *parentComment;


- (instancetype)initWithCommentUserId:(NSString *)commentUserId
                  commentUserNickname:(NSString *)commentUserNickname
                       commentContent:(NSString *)commentContent
            parentCommentUserNickname:(NSString *)parentCommentUserNickname commentDatetime:(NSString *)commentDatetime;
//parentComment =                 {
//    code = PL20170410311154162;
//    commDatetime = "Apr 13, 2017 11:15:41 AM";
//    commer = U2017041311023219056;
//    content = "\U4e0d\U9519 \U8c01\U56de\U590d\U6211\U4e0b";
//    loginName = CSW15122223333;
//    nickname = 1512233;
//    parentCode = TZ20170410311121858;
//    photo = "c7d27b24-d1d7-45f0-ba19-3ae7433e215e.JPG";
//    postCode = TZ20170410311121858;
//    status = B;
//};

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
