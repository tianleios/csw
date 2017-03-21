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

@interface CSWTimeLineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;
@property (nonatomic, strong) CSWSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;

@end

@implementation CSWTimeLineVC

- (CSWLayoutItem *)layoutItem {

    if (!_layoutItem) {
        
        _layoutItem = [[CSWLayoutItem alloc] init];
        _layoutItem.article = [CSWArticleModel new];
    }
    return _layoutItem;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //left-search
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"headline_search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //right-send
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
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
    self.timeLineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    [self.view addSubview:self.timeLineTableView];
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    
    //添加
    [bgScrollView addSubview:self.timeLineTableView];
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
    return  self.layoutItem.cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
        
    }
    

    cell.layoutItem = self.layoutItem;
    return cell;

}

@end
