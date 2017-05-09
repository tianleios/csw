//
//  CSWFansVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWFansVC.h"
#import "CSWFansCell.h"
#import "CSWUserDetailVC.h"

@interface CSWFansVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CSWFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝";
    
    TLTableView *fansTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    fansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansTableView];
    [fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
//    userDetailVC.type = CSWUserDetailVCTypeOther;
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 70;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWFansCellID"];
    if (!cell) {
        
        cell = [[CSWFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWFansCellID"];
        
    }
    
    return cell;

}

@end
