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

@interface CSWMineVC ()<UITableViewDataSource,UITableViewDelegate,CSWMineHeaderSeletedDelegate>

@property (nonatomic, strong) CSWMineHeaderView *headerView;
@property (nonatomic, strong) TLSettingGroup *group;
@end

@implementation CSWMineVC
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.alpha = 0;
    
}


//---//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    TLTableView *mineTableView = [TLTableView groupTableViewWithframe:CGRectZero
                                                        delegate:self
                                                      dataSource:self];
    [self.view addSubview:mineTableView];
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    mineTableView.rowHeight = 45;
    
    //headerView
    CSWMineHeaderView *mineHeaderView = [[CSWMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    mineTableView.tableHeaderView = mineHeaderView;
    mineHeaderView.delegate = self;
    self.headerView = mineHeaderView;
    
    //
    [self data];
    
}

#pragma mark- 头部条状 事件处理
- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {

    if (type == MineHeaderSeletedTypeDefault) {
        //个人中心
        CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
        userDetailVC.type = CSWUserDetailVCTypeMine;
        [self.navigationController pushViewController:userDetailVC animated:YES];
        
//        CSWUserDetailEditVC *userDetailVC = [[CSWUserDetailEditVC alloc] init];
//        [self.navigationController pushViewController:userDetailVC animated:YES];
        
        
    } else {
        //各种流水
        switch (idx) {
            case 0: {//帖子
            
                CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
                userDetailVC.type = CSWUserDetailVCTypeMine;
                [self.navigationController pushViewController:userDetailVC animated:YES];
                
            }
            break;
                
            case 1: {//关注
                
                CSWFansVC *fansVC = [[CSWFansVC alloc] init];
                [self.navigationController pushViewController:fansVC animated:YES];
                
            }
            break;
                
            case 2: {//粉丝
                
                CSWFansVC *fansVC = [[CSWFansVC alloc] init];
                [self.navigationController pushViewController:fansVC animated:YES];
                
            }
            break;
                
            case 3: {//赏金
                
                CSWMoneyRewardFlowVC *vc = [CSWMoneyRewardFlowVC new];
                [self.navigationController pushViewController:vc animated:YES];
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

- (void)data {

    self.headerView.userPhoto.image = [UIImage imageNamed:@"头像"];
    self.headerView.nameLbl.text = @"敌法师";
    self.headerView.levelLbl.text = @"论坛绞肉机";
    self.headerView.numberArray = @[@1,@323,@3332,@111];

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
