//
//  CSWAtUserSearchVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/5/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWAtUserSearchVC.h"
#import "CSWFansCell.h"
#import "CSWRelationUserModel.h"


@interface CSWAtUserSearchVC ()

@property (nonatomic, strong) TLTableView *atTableView;
@property (nonatomic, copy) NSArray<CSWRelationUserModel *> *users;


@end

@implementation CSWAtUserSearchVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.atTableView beginRefreshing];

}



- (void)cancle {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//--//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    TLTableView *atTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    self.atTableView = atTableView;

    atTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:atTableView];
    [atTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    TLPageDataHelper *pageDateHelper = [[TLPageDataHelper alloc] init];
    pageDateHelper.code = @"805090";
    pageDateHelper.tableView = atTableView;
    
    //查询我关注的人
    pageDateHelper.parameters[@"userId"] = [TLUser user].userId;
    pageDateHelper.parameters[@"token"] = [TLUser user].token;
    [pageDateHelper modelClass:[CSWRelationUserModel class]];


    __weak typeof(self) weakself = self;
    [atTableView addRefreshAction:^{
        
        [pageDateHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.atTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    //--//
    [atTableView addLoadMoreAction:^{
        
        [pageDateHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.atTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.chooseUserAction) {
        
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            self.chooseUserAction(self.users[indexPath.row].nickname);

        }];
        
    }
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
