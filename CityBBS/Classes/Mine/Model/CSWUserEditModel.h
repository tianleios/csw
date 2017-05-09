//
//  CSWUserEditModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWUserEditModel : TLBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;


@property (nonatomic, copy) NSString *url;
//@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIImage *img;



@end
