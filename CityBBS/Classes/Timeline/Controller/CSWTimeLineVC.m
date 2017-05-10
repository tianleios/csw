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
#import "TLUserLoginVC.h"

@interface CSWTimeLineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;
@property (nonatomic, strong) CSWSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;
@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*timeLineLayoutItemRoom;

@property (nonatomic, assign) BOOL isFirst;
//@property (nonatomic, strong) TLNetworking *timelinHttp;
@property (nonatomic, strong) TLPageDataHelper *timeLinePageDataHelper;

@end

@implementation CSWTimeLineVC

- (CSWLayoutItem *)layoutItem {

    if (!_layoutItem) {
        
        _layoutItem = [[CSWLayoutItem alloc] init];
        _layoutItem.article = [CSWArticleModel new];
    }
    return _layoutItem;

}

- (NSMutableArray<CSWLayoutItem *> *)timeLineLayoutItemRoom {

    if (!_timeLineLayoutItemRoom) {
        
        _timeLineLayoutItemRoom = [NSMutableArray new];
    }
    
    return _timeLineLayoutItemRoom;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];
    
    
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

    //论坛版块相关
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
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = @"610130";
    timeLinePageData.parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
    timeLinePageData.tableView = self.timeLineTableView;
    [timeLinePageData modelClass:[CSWArticleModel class]];
    self.timeLinePageDataHelper = timeLinePageData;
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    
    
    //
    [self.timeLineTableView addRefreshAction:^{
        
        [timeLinePageData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.timeLineLayoutItemRoom = objs;
            [weakSelf.timeLineTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.timeLineTableView addLoadMoreAction:^{
        
        [timeLinePageData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.timeLineLayoutItemRoom = objs;
            [weakSelf.timeLineTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
  
    

    

}


- (void)cityChange {

     self.timeLinePageDataHelper
         .parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
     [self.timeLineTableView beginRefreshing];
    
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
    
    
    if (![TLUser user].userId) {
        
        TLNavigationController *navCtrl = [[TLNavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
        [self presentViewController:navCtrl animated:YES completion:nil];
        return;
    }
    
    
    TLComposeVC *composeVC = [[TLComposeVC alloc] init];
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    //计算
//    return  self.layoutItem.cellHeight;
    return self.timeLineLayoutItemRoom[indexPath.row].cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    layoutItem.article = self.timeLineLayoutItemRoom[indexPath.row].article;
    //
//    detailVC.layoutItem = layoutItem;
    detailVC.articleCode = layoutItem.article.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.timeLineLayoutItemRoom.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        
        CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
        if (!cell) {
            
            cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
            
        }
        
        
        //    cell.layoutItem = self.layoutItem;
        cell.layoutItem = self.timeLineLayoutItemRoom[indexPath.row];
        return cell;

  
    
}

@end
