//
//  CSWTimeLineVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWTimeLineVC.h"
#import "TLNavigationController.h"
#import "TLComposeVC.h"
#import "CSWTimeLineCell.h"
#import "CSWLayoutItem.h"
#import "CSWArticleDetailVC.h"
#import "CSWSwitchView.h"
#import "CSWForumVC.h"
#import "CSWArticleModel.h"

@interface CSWTimeLineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;
@property (nonatomic, strong) CSWSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;
@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*timeLineLayoutItemRooom;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) TLNetworking *timelinHttp;

@end

@implementation CSWTimeLineVC

- (CSWLayoutItem *)layoutItem {

    if (!_layoutItem) {
        
        _layoutItem = [[CSWLayoutItem alloc] init];
        _layoutItem.article = [CSWArticleModel new];
    }
    return _layoutItem;

}

- (NSMutableArray<CSWLayoutItem *> *)timeLineLayoutItemRooom {

    if (!_timeLineLayoutItemRooom) {
        
        _timeLineLayoutItemRooom = [NSMutableArray new];
    }
    
    return _timeLineLayoutItemRooom;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (self.isFirst) {
        [self.timeLineTableView beginRefreshing];
        self.isFirst = NO;
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //left-search
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"headline_search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //right-send
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
    self.isFirst = YES;
    //顶部有料和论坛的切换
    CGFloat h = 35;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - h, 120, h)];
    headerView.centerX = [UIScreen mainScreen].bounds.size.width/2.0;
//    headerView.backgroundColor = [UIColor orangeColor];
   

    
    //背景
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, bgScrollView.height);
    [self.view addSubview:bgScrollView];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.delegate = self;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    
    //时间线table
    self.timeLineTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    [bgScrollView addSubview:self.timeLineTableView];
    self.timeLineTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];

    //添加
    CSWForumVC *forumVC = [[CSWForumVC alloc] init];
    [self addChildViewController:forumVC];
    forumVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [bgScrollView addSubview:forumVC.view];
    
    __weak typeof(self) weakSelf = self;
    self.switchBySwitchView = NO;
    CSWSwitchView *switchView = [[CSWSwitchView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, 40)];
    [headerView addSubview:switchView];
    self.switchView = switchView;
    
    self.navigationItem.titleView = headerView;
    switchView.selected = ^(NSInteger idx){
    
        weakSelf.switchBySwitchView = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.switchBySwitchView = NO;

        });
        [bgScrollView setContentOffset:CGPointMake(idx*bgScrollView.width, 0) animated:YES];
        
        
    };
    
    
#pragma mark- 时间线刷新时间
    [self.timeLineTableView addRefreshAction:^{
        
        weakSelf.timelinHttp = [TLNetworking new];
        weakSelf.timelinHttp.code = @"610130";
        weakSelf.timelinHttp.parameters[@"companyCode"] =  @"GS2017041117035605752";
//        [CSWCityManager manager].currentCity.code;
        weakSelf.timelinHttp.parameters[@"start"] = @"1";
        weakSelf.timelinHttp.parameters[@"limit"] = @"10";
        
        [weakSelf.timelinHttp postWithSuccess:^(id responseObject) {
            
            NSArray *arrticleArr =  responseObject[@"data"][@"list"];
            [arrticleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
              CSWArticleModel *model =  [CSWArticleModel tl_objectWithDictionary:obj];
                CSWLayoutItem *layoutItem = [CSWLayoutItem new];
              layoutItem.article = model;
              [weakSelf.timeLineLayoutItemRooom addObject:layoutItem];
                
            }];
            
            [weakSelf.timeLineTableView reloadData_tl];
            [weakSelf.timeLineTableView endRefreshHeader];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];


    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.switchBySwitchView) {
        
    } else {
    
        if ([scrollView isMemberOfClass:[UIScrollView class]]) {
            
            self.switchView.selectedIndex  =  scrollView.contentOffset.x/scrollView.width;
            
        }
    
    }
    
}

#pragma mark- 用户 帖子搜索
- (void)search {
    
}

#pragma mark- 发布帖子
- (void)compose {
    
    TLComposeVC *composeVC = [[TLComposeVC alloc] init];
    
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    //计算
//    return  self.layoutItem.cellHeight;
    return self.timeLineLayoutItemRooom[indexPath.row].cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    detailVC.layoutItem = self.timeLineLayoutItemRooom[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.timeLineLayoutItemRooom.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        
        CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
        if (!cell) {
            
            cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
            
        }
        
        
        //    cell.layoutItem = self.layoutItem;
        cell.layoutItem = self.timeLineLayoutItemRooom[indexPath.row];
        return cell;

  
    
}

@end
