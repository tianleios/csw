//
//  CSWForumVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWForumVC.h"
#import "MJRefresh.h"
#import "CSWForumGeneraCell.h"
#import "CSWSubClassCell.h"
#import "CSWPlateDetailVC.h"

@interface CSWForumVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation CSWForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //leftTa
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    [self.view addSubview:self.leftTableView];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(120);
    }];
    self.leftTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.rightTableView.backgroundColor = [UIColor whiteColor];

    //右边
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.rightTableView];
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.equalTo(self.leftTableView.mas_top);
        make.bottom.equalTo(self.leftTableView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
}


#pragma mark-- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //
    if ([tableView isEqual:self.rightTableView]) {
        
        CSWPlateDetailVC *plateDetailVC = [[CSWPlateDetailVC alloc] init];
        
        [self.navigationController pushViewController:plateDetailVC animated:YES];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }
    //

}

#pragma mark-- dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.leftTableView]) {
        
        return 50;
        
    } else {
        
        return 90;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([tableView isEqual:self.leftTableView]) {
        return 10;

    } else {
    
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.leftTableView]) {
   
        
        CSWForumGeneraCell *cell = [CSWForumGeneraCell cellWithTableView:tableView indexPath:indexPath];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIColor whiteColor] convertToImage]];
        if (indexPath.row == 9) {
//            cell.selected = YES;
//            [cell setSelected:YES animated:YES];
              [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;
        
    } else {
    
        CSWSubClassCell *cell = [CSWSubClassCell cellWithTableView:tableView indexPath:indexPath];
        
        return cell;
    
    }

}

@end
