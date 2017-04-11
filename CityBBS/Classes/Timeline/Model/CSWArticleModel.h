//
//  CSWArticleModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "CSWCommentModel.h"

@interface CSWArticleModel : TLBaseModel

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSArray *photos;
//
//@property (nonatomic, strong) NSArray *dzArray;
//@property (nonatomic, strong) NSArray<CSWCommentModel *> *comments;


@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray <NSString *>*picArr;     //图片

@property (nonatomic, copy, readonly) NSArray *thumbnailUrls;
@property (nonatomic, copy, readonly) NSArray *originalUrls;


@property (nonatomic, copy) NSArray <CSWCommentModel *>*commentList;
@property (nonatomic, copy) NSArray *likeList;

@property (nonatomic, copy) NSString *plateName;

//user
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *publishDatetime;
@property (nonatomic, copy) NSString *photo;

//统计
@property (nonatomic, strong) NSNumber *sumComment;
@property (nonatomic, strong) NSNumber *sumLike;
@property (nonatomic, strong) NSNumber *sumRead;
@property (nonatomic, strong) NSNumber *sumReward;

//用户处于登录状态
@property (nonatomic, strong) NSNumber *isDZ; //点赞
@property (nonatomic, strong) NSNumber *isLock; //锁帖
@property (nonatomic, strong) NSNumber *isSC; //收藏



//code = TZ20170410112062331;
//commentList =                 (
//);
//content = "Tukjhjjjd[\U9ed1\U7ebf][\U6316\U9f3b]@yeueuus@urujdjsj@usijdjd @udhdhsj hshjsjsjsjsjsjsjsjsjsj";
//isDZ = 0;
//isLock = 0;
//isSC = 0;
//likeList =                 (
//);
//location = D;
//loginName = 13868074590;
//nickname = 53002169;
//orderNo = 0;
//picArr =                 (
//                          "iOS_1491840411919866_1280_950.jpg",
//                          "iOS_1491840411920021_1280_950.jpg"
//                          );
//plateCode = SPK201704911043043461;
//plateName = "\U901a\U5929\U5854 ";
//publishDatetime = "Apr 11, 2017 12:06:23 AM";
//publisher = U2017041016353002169;
//status = C1;
//sumComment = 0;
//sumLike = 0;
//sumRead = 0;
//sumReward = 0;
//title = Tuuu;
@end
