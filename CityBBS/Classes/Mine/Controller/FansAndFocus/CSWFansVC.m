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
#import "CSWRelationUserModel.h"

@interface CSWFansVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray<CSWRelationUserModel *> *users;
@property (nonatomic, strong) TLTableView *fansOrFocusTableView;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWFansVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.fansOrFocusTableView beginRefreshing];
        self.isFirst = NO;
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    TLTableView *fansOrFocusTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    self.fansOrFocusTableView = fansOrFocusTableView;
    fansOrFocusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansOrFocusTableView];
    [fansOrFocusTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    fansOrFocusTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
    TLPageDataHelper *pageDateHelper = [[TLPageDataHelper alloc] init];
    pageDateHelper.code = @"805090";
    pageDateHelper.tableView = fansOrFocusTableView;
    
    //
    pageDateHelper.parameters[@"userId"] = [TLUser user].userId;
    pageDateHelper.parameters[@"token"] = [TLUser user].token;
    [pageDateHelper modelClass:[CSWRelationUserModel class]];

    //--//
    if (self.type == CSWReleationTypeFans) { //查询粉丝
        self.title = @"粉丝";
        
        //谁关主了这个人    
        pageDateHelper.parameters[@"toUser"] = [TLUser user].userId;

    } else {//查询关注
        
        self.title = @"关注";
        //我关注了谁
        pageDateHelper.parameters[@"userId"] = [TLUser user].userId;

        
    }
    
    __weak typeof(self) weakself = self;
    [fansOrFocusTableView addRefreshAction:^{
        
        [pageDateHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.fansOrFocusTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    

    [fansOrFocusTableView addLoadMoreAction:^{
        
        [pageDateHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.fansOrFocusTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
 
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    //
    CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
    userDetailVC.userId = self.users[indexPath.row].userId;
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.users.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWFansCellID"];
    if (!cell) {
        
        cell = [[CSWFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWFansCellID"];
        
    }
    
    //
    cell.user = self.users[indexPath.row];
    
    return cell;

}

@end
