//
//  CSWAtUserSearchVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/5/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface CSWAtUserSearchVC : TLBaseVC

@property (nonatomic, copy) void(^chooseUserAction)(NSString *nickname);

@end
