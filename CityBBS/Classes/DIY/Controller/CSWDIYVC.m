//
//  CSWDIYVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYVC.h"
#import "CSWDIYOverAllVC.h"
#import "CSWDIYPartVC.h"


@interface CSWDIYVC ()

//整体自定义
@property (nonatomic, strong) CSWDIYOverAllVC *overAllVC;

//局部自定义
@property (nonatomic, strong) CSWDIYPartVC *partVC;

@end

@implementation CSWDIYVC

- (CSWDIYOverAllVC *)overAllVC {

    if (!_overAllVC) {
        
        _overAllVC = [[CSWDIYOverAllVC alloc] init];
        
    }
    return _overAllVC;

}


- (CSWDIYPartVC *)partVC {
    
    if (!_partVC) {
        
        _partVC = [[CSWDIYPartVC alloc] init];
        
    }
    return _partVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DIY";
    
    if (0) { //整体
        
        [self addChildViewController:self.overAllVC];
        [self.view addSubview:self.overAllVC.view];
        [self.overAllVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
    } else { //局部
    
        [self addChildViewController:self.partVC];
        
//        self.partVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:self.partVC.view];
        [self.partVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
