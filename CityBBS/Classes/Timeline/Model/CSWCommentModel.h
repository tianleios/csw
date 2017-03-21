//
//  CSWCommentModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSWCommentModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSString *commentText;

//回复人
@property (nonatomic, copy) NSString *reUserId;
@property (nonatomic, strong) NSString *reCommentText;

@end
