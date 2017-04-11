//
//  CSWArticleDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleDetailVC.h"
#import "CSWTimeLineCell.h"
#import "CSWDaShangCell.h"
#import "CSWUserActionSwitchView.h"


@interface CSWArticleDetailVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) TLTableView *articleDetailTableView;
@property (nonatomic, strong) CSWUserActionSwitchView *userActionSwitchView;
@end

@implementation CSWArticleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子详情";
    
    self.articleDetailTableView = [TLTableView  groupTableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.articleDetailTableView];
    
    [self.articleDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
    }];

}

- (CSWUserActionSwitchView *)userActionSwitchView {

    if (!_userActionSwitchView) {
        
        _userActionSwitchView = [[CSWUserActionSwitchView alloc] init];
    }
    
    return _userActionSwitchView;

}


#pragma dataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2) {
        
        return self.userActionSwitchView;
    }
    return nil;

}

//--//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
    
        return 15;

    }
    
    return 40;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return self.layoutItem.cellHeight;
        
    } else if (indexPath.section == 1) {
    
        return 80;
        
    }
    
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
        
    }
    
    
    //    cell.layoutItem = self.layoutItem;
    cell.layoutItem = self.layoutItem;
    return cell;
        
    } else if (indexPath.section == 1) {
    
        
    
        CSWDaShangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWDaShangCellId"];
        if (!cell) {
            
            cell = [[CSWDaShangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWDaShangCellId"];
            
        }
        
        return cell;
    
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    return cell;
    
    
}


@end
