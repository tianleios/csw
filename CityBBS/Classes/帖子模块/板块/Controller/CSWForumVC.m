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
#import "CSWBigPlateModel.h"
#import "CSWSmallPlateModel.h"

@interface CSWForumVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) TLTableView *rightTableView;

@property (nonatomic, copy) NSArray <CSWBigPlateModel *>*bigPlateRoom;
@property (nonatomic, copy) NSArray <CSWSmallPlateModel *>*smallPlateRoom;

@property (nonatomic, strong) TLPageDataHelper *rightPageDateHelper;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWForumVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.rightPageDateHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    
    if (self.isFirst) {
        
        [self.leftTableView.mj_header beginRefreshing];
        self.isFirst = NO;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    //leftTa
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
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
    self.rightTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.rightTableView];
    self.rightTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无板块"];
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.equalTo(self.leftTableView.mas_top);
        make.bottom.equalTo(self.leftTableView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    //左侧大类
    __weak typeof(self) weakSelf = self;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"610027";
        http.parameters[@"status"] = @"1";
        http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
        [http postWithSuccess:^(id responseObject) {
            
            weakSelf.bigPlateRoom  =  [CSWBigPlateModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            [weakSelf.leftTableView reloadData];
            [weakSelf.leftTableView.mj_header endRefreshing];
            [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            //刷新右测
            weakSelf.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom.count > 0 ? self.bigPlateRoom[0].code : @"xxxxxx";
            
            [weakSelf.rightTableView beginRefreshing];
            
        } failure:^(NSError *error) {
            
            [weakSelf.leftTableView.mj_header endRefreshing];

        }];

    }];
    
    
    //右侧 小版块 刷新---事件
    //parentCode  和 companyCode 在合适的时候改变
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"610045";
    helper.parameters[@"status"] = @"1";
    helper.tableView = self.rightTableView;
    self.rightPageDateHelper = helper;
    [helper modelClass:[CSWSmallPlateModel class]];
    
    //
    [self.rightTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.smallPlateRoom = objs;
            [weakSelf.rightTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
   
    [self.rightTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.smallPlateRoom = objs;
            [weakSelf.rightTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];
}



#pragma mark- 城市切换
- (void)cityChange {

    [self.leftTableView.mj_header beginRefreshing];
    
}

#pragma mark-- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //
    if ([tableView isEqual:self.rightTableView]) {
        
        CSWPlateDetailVC *plateDetailVC = [[CSWPlateDetailVC alloc] init];
        
        plateDetailVC.plateCode = self.smallPlateRoom[indexPath.row].code;
        [self.navigationController pushViewController:plateDetailVC animated:YES];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }
    //left
    
    self.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom[indexPath.row].code;
    [self.rightTableView beginRefreshing];
    

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
        return self.bigPlateRoom.count;

    } else {
    
        return self.smallPlateRoom.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.leftTableView]) {
   
        
        CSWForumGeneraCell *cell = [CSWForumGeneraCell cellWithTableView:tableView indexPath:indexPath];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIColor whiteColor] convertToImage]];
//        if (indexPath.row == 9) {
////            cell.selected = YES;
////            [cell setSelected:YES animated:YES];
//           
//        }
        
        cell.nameLbl.text = self.bigPlateRoom[indexPath.row].name;
        return cell;
        
    } else {
    
        CSWSubClassCell *cell = [CSWSubClassCell cellWithTableView:tableView indexPath:indexPath];
        
        CSWSmallPlateModel *small = self.smallPlateRoom[indexPath.row];
        
        [cell.subClassImageView sd_setImageWithURL:[NSURL URLWithString:[small.pic convertImageUrl]] placeholderImage:nil];
        cell.nameLbl.text = small.name;
        return cell;
    
    }

}

@end
