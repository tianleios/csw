//
//  CSWEditVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

#import "CSWUserEditModel.h"

typedef  NS_ENUM(NSInteger,CSWUserEditType) {

    CSWUserEditTypeNickName = 0,
    CSWUserEditTypeEmail

};



@interface CSWEditVC : TLBaseVC

@property (nonatomic, strong) CSWUserEditModel *editModel;
@property (nonatomic, copy) void (^done)();
@property (nonatomic, assign) CSWUserEditType type;


@end
