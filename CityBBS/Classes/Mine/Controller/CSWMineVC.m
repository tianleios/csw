//
//  CSWMineVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWMineVC.h"
#import "CSWMineHeaderView.h"
#import "CSWSettingCell.h"
#import "TLSettingGroup.h"
#import "CSWUserDetailVC.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"

#import "CSWUserDetailEditVC.h"
#import "CSWSetVC.h"
#import "TLAboutUsVC.h"
#import "CSWFansVC.h"
#import "CSWMoneyRewardFlowVC.h"
#import "ConversationListVC.h"

@interface CSWMineVC ()<UITableViewDataSource,UITableViewDelegate,CSWMineHeaderSeletedDelegate>

@property (nonatomic, strong) CSWMineHeaderView *headerView;
@property (nonatomic, strong) TLSettingGroup *group;
@property (nonatomic, strong) TLTableView *mineTableView;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWMineVC
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if (self.isFirst) {
        
        [self.mineTableView beginRefreshing];
        self.isFirst = NO;
    }
    
    //--//
}


//---//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.isFirst = YES;
    
    TLTableView *mineTableView = [TLTableView groupTableViewWithframe:CGRectZero
                                                        delegate:self
                                                      dataSource:self];
    [self.view addSubview:mineTableView];
//    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    mineTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    mineTableView.rowHeight = 45;
    self.mineTableView = mineTableView;
    
    
    //tableview的header
    //headerView
    CSWMineHeaderView *mineHeaderView = [[CSWMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    mineTableView.tableHeaderView = mineHeaderView;
    mineHeaderView.delegate = self;
    self.headerView = mineHeaderView;
    
    //
    [self userInfoChange];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:kUserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    
    __weak typeof(self) weakself = self;
    //添加刷新行为
    [mineTableView addRefreshAction:^{
        
        //1.刷新用户信息
        [[TLUser user] updateUserInfo];
        
        //2.获取帖子数目
        //NO_A 非草稿状态，BD 已发布和审核通过 CC 待审核
        TLNetworking *http = [TLNetworking new];
        http.code = @"610150";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"status"] = @"BD";
        [http postWithSuccess:^(id responseObject) {
            
           NSNumber *totalNum = responseObject[@"data"];
            
           //
            weakself.headerView.articelNum = totalNum;
            [weakself.mineTableView endRefreshHeader];
            
        } failure:^(NSError *error) {
            
            [weakself.mineTableView endRefreshHeader];
            
        }];
        
        
        //--//
        //刷新赏金
        TLNetworking *sjHttp = [TLNetworking new];
        sjHttp.code = @"802503";
        sjHttp.parameters[@"userId"] = [TLUser user].userId;
        sjHttp.parameters[@"token"] = [TLUser user].token;
        [sjHttp postWithSuccess:^(id responseObject) {
            
            NSArray <NSDictionary *> *arr = responseObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj[@"currency"] isEqualToString:@"JF"]) {
                    
                    weakself.headerView.sjNumText = [obj[@"amount"] convertToRealMoney];
                }
                
            }];
            
            
            
        } failure:^(NSError *error) {
            
            
        }];


        
    }];
    
}

//用户退出
- (void)userLoginOut {

    //
    [self.headerView.userPhoto sd_setImageWithURL:nil placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    [self.headerView reset];
    
    //
    self.headerView.nameLbl.text = @"--";
    
    //论坛-绞肉机
    self.headerView.levelLbl.text = @"--";
    

}

//用户登录
- (void)userLogin {

    [self.mineTableView beginRefreshing];
    
//  [self userInfoChange];
    
    
}


//
- (void)userInfoChange {
    
    NSString *userPhotoStr = [[TLUser user].userExt.photo convertThumbnailImageUrl];
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
     
     
    self.headerView.nameLbl.text = [TLUser user].nickname;
    
    //论坛-绞肉机
    self.headerView.levelLbl.text = [TLUser user].level;
    
    //
    self.headerView.focusNum = [TLUser user].totalFollowNum;

    self.headerView.fansNum = [TLUser user].totalFansNum;
    //
    
}


#pragma mark- 头部条状 事件处理
- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {

    if (type == MineHeaderSeletedTypeDefault) {
        //个人中心
        CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
        userDetailVC.userId = [TLUser user].userId;
        
        [self.navigationController pushViewController:userDetailVC animated:YES];
        
        
    } else {
        //各种流水
        switch (idx) {
            case 0: {//帖子
            
                CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
                userDetailVC.userId = [TLUser user].userId;
                [self.navigationController pushViewController:userDetailVC animated:YES];
                
            }
            break;
                
            case 1: {//关注
                
                CSWFansVC *fansVC = [[CSWFansVC alloc] init];
                fansVC.type = CSWReleationTypeFocus;
                [self.navigationController pushViewController:fansVC animated:YES];
                
            }
            break;
                
            case 2: {//粉丝
                
                CSWFansVC *fansVC = [[CSWFansVC alloc] init];
                fansVC.type = CSWReleationTypeFans;
                [self.navigationController pushViewController:fansVC animated:YES];
                
            }
            break;
                
            case 3: {//赏金
                
                TLNetworking *sjHttp = [TLNetworking new];
                sjHttp.code = @"802503";
                sjHttp.parameters[@"userId"] = [TLUser user].userId;
                sjHttp.parameters[@"token"] = [TLUser user].token;
                [sjHttp postWithSuccess:^(id responseObject) {
                    
                    NSArray <NSDictionary *> *arr = responseObject[@"data"];
                    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([obj[@"currency"] isEqualToString:@"JF"]) {
                            
                            CSWMoneyRewardFlowVC *vc = [CSWMoneyRewardFlowVC new];
                            vc.accountNumber = obj[@"accountNumber"];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }];
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
            
            }
            break;
                

        }
    
    }
    
}


- (TLSettingGroup *)group {

    if (!_group) {
        
        __weak typeof(self) weakSelf = self;
        _group = [[TLSettingGroup alloc] init];
        
        NSArray *names = @[@"我的物品",@"我的收藏",@"草稿箱",@"我的消息",@"关于城市网",@"设置"];

        //我的物品
        TLSettingModel *goodsItem = [TLSettingModel new];
        goodsItem.imgName = @"我的物品";
        goodsItem.text  = @"我的物品";
        [goodsItem setAction:^{
           
            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:[TLUserLoginVC new]];
            
            [self presentViewController:nav animated:YES completion:nil];
//            [weakSelf.navigationController pushViewController:[TLUserLoginVC new] animated:YES];
            
        }];
        
        //collectItem
        TLSettingModel *collectItem = [TLSettingModel new];
        collectItem.imgName = @"我的收藏";
        collectItem.text  = @"我的收藏";
        [collectItem setAction:^{
            

            
        }];
        
        //draft
        TLSettingModel *draftItem = [TLSettingModel new];
        draftItem.imgName = @"草稿箱";
        draftItem.text  = @"草稿箱";
        [draftItem setAction:^{
            
            
        }];
        
        //我的消息
        TLSettingModel *msgItem = [TLSettingModel new];
        msgItem.imgName = @"我的消息";
        msgItem.text  = @"我的消息";
        [msgItem setAction:^{
            
            ConversationListVC *chatListV = [[ConversationListVC alloc] init];
            [self.navigationController pushViewController:chatListV animated:YES];
            
        }];
        
        //我的物品
        TLSettingModel *aboutItem = [TLSettingModel new];
        aboutItem.imgName = @"关于我们";
        aboutItem.text  = @"关于我们";
        [aboutItem setAction:^{
            
            TLAboutUsVC *aboutVC = [TLAboutUsVC new];
            [weakSelf.navigationController pushViewController:aboutVC animated:YES];
            
        }];
        //我的物品
        TLSettingModel *setItem = [TLSettingModel new];
        setItem.imgName = @"设置";
        setItem.text  = @"设置";
        [setItem setAction:^{
            
            CSWSetVC *setVC = [CSWSetVC new];
            [weakSelf.navigationController pushViewController:setVC animated:YES];
            
        }];
        
        _group.items = @[goodsItem,collectItem,draftItem,msgItem,aboutItem,setItem];
        
    }
    return _group;

}



#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark- datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSettingCellID"];
    
    if (!cell) {
        
        cell = [[CSWSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSettingCellID"];
        
    }
    
    //
    cell.settingModel = self.group.items[indexPath.row];
    //
    
    return cell;
    
}

@end
