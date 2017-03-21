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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *photos;

@property (nonatomic, strong) NSArray *dzArray;
@property (nonatomic, strong) NSArray<CSWCommentModel *> *comments;

@end
