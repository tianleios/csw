//
//  CSWSetVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSetVC.h"
#import "TLSettingGroup.h"
#import "CSWUserDetailEditVC.h"
#import "TLChangeMobileVC.h"
#import "TLUserForgetPwdVC.h"
#import "TLTabBar.h"

@interface CSWSetVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TLSettingGroup *group;
@property (nonatomic, strong) UIButton *loginOutBtn;
@end

@implementation CSWSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    mineTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    [self.view addSubview:mineTableView];
    
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    mineTableView.rowHeight = 45;
    mineTableView.tableFooterView = self.loginOutBtn;
    __weak typeof(self) weakSelf = self;
    //
    TLSettingModel *changeLoginName = [TLSettingModel new];
    changeLoginName.text = @"修改登录名";
    [changeLoginName setAction:^{
        
        
        
    }];
    
    //
    TLSettingModel *loginNameAndPwd = [TLSettingModel new];
    loginNameAndPwd.text = @"账号和密码";
    [loginNameAndPwd setAction:^{
        
        TLUserForgetPwdVC *forgetPwdVC = [[TLUserForgetPwdVC alloc] init];
        [weakSelf.navigationController pushViewController:forgetPwdVC animated:YES];
        
    }];
    
    //
    TLSettingModel *changePhone = [TLSettingModel new];
    changePhone.text = @"修改手机号";
    [changePhone setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
    }];
    
    //
    TLSettingModel *userDetail = [TLSettingModel new];
    userDetail.text = @"个人资料";
    [userDetail setAction:^{
        
        CSWUserDetailEditVC *editVC = [[CSWUserDetailEditVC alloc] init];
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    }];
    
    //
    TLSettingModel *clear = [TLSettingModel new];
    clear.text = @"清除缓存";
    [clear setAction:^{
        
        NSLog(@"清除缓存");
    }];
    
    self.group = [TLSettingGroup new];
    self.group.items = @[changeLoginName,loginNameAndPwd,changePhone,userDetail,clear];
    

}


#pragma mark- 退出登录
- (void)loginOut {

    UITabBarController *tbcController = self.tabBarController;
    
    //
    [self.navigationController popViewControllerAnimated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tbcController.selectedIndex = 0;
        
//        tbcController.tabBar
        TLTabBar *tabBar = (TLTabBar *)tbcController.tabBar;
        tabBar.selectedIdx = 0;
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    
    
}

- (UIButton *)loginOutBtn {

    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _loginOutBtn.backgroundColor = [UIColor whiteColor];
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return   self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = FONT(14);
        
    }
    
    cell.textLabel.text = self.group.items[indexPath.row].text;
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        
        cell.detailTextLabel.text = @"1M";

    }
    return cell;

}




@end
