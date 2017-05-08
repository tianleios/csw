//
//  CSWUserPhotoView.m
//  CityBBS
//
//  Created by  tianlei on 2017/5/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserPhotoView.h"
#import "CSWUserDetailVC.h"

@implementation CSWUserPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addAction];
     
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAction];
    }
    return self;
}


- (void)addAction {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserDetail)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
}

- (void)goUserDetail {

    
    if (!self.userId) {
        [TLAlert alertWithError:@"无 userId"];
        return;
    }
    
    UINavigationController *nav = [self nextNavController];
    CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
    userDetailVC.userId = self.userId;
    //
    [nav pushViewController:userDetailVC animated:YES];

}

@end
