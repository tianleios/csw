//
//  CSWPlateDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWPlateDetailVC.h"
#import "TLNavigationController.h"
#import "TLComposeVC.h"
#import "CSWArticleTypeSwitchView.h"
#import "CSWPlateHeaderView.h"

@interface CSWPlateDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *switchScrollView;

@property (nonatomic, strong) TLTableView *allTableView;
@property (nonatomic, strong) TLTableView *lastTableView;
@property (nonatomic, strong) TLTableView *essenceTableView;

@property (nonatomic, strong) CSWPlateHeaderView *falseHeaderView;
@property (nonatomic, strong) CSWArticleTypeSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;

@end

@implementation CSWPlateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"板块名称";
   UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"headline_search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //right-send
    UIBarButtonItem *composeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
    self.navigationItem.rightBarButtonItems = @[searchBarButtonItem,composeBarButtonItem];
    
    //背景
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
    [self.view addSubview:self.switchScrollView];
    [self.switchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.switchScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.switchScrollView.pagingEnabled = YES;
    self.switchScrollView.delegate = self;

    //伪头部
    self.falseHeaderView = [[CSWPlateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    self.falseHeaderView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.falseHeaderView];
    self.falseHeaderView.plateImageView.backgroundColor = [UIColor orangeColor];
    self.falseHeaderView.nameLbl.text = @"神马板块";
    
    
    //
    self.switchBySwitchView = NO;
    self.switchView = [[CSWArticleTypeSwitchView alloc] initWithFrame:CGRectMake(0, self.falseHeaderView.yy, self.falseHeaderView.width, 40)];
    self.switchView.itemWidth = 55;
    self.switchView.intervalMargin = 45;
    self.switchView.typeNames = @[@"全部",@"最新",@"精华"];
    [self.view addSubview:self.switchView];
    __weak typeof(self) weakSelf = self;
    [self.switchView setSelected:^(NSInteger idx) {
        
        weakSelf.switchBySwitchView = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.switchBySwitchView = NO;
            
        });
        [weakSelf.switchScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
        
    }];
    
    
    //
    self.allTableView  = [self tableViewWithFrame:self.switchScrollView.bounds];
    [self.switchScrollView addSubview:self.allTableView];
    
    //
    self.lastTableView  = [self tableViewWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.allTableView.height)];
    [self.switchScrollView addSubview:self.lastTableView];
    
    //
    self.essenceTableView  = [self tableViewWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.allTableView.height)];
    [self.switchScrollView addSubview:self.essenceTableView];
    
}

//--//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        if (self.switchBySwitchView) {
            
            
        } else {
        
            NSInteger idx = scrollView.contentOffset.x/scrollView.width;
            self.switchView.selectedIdx = idx;
        }
    
        return;
    }

    if (![scrollView isMemberOfClass:[UIScrollView class]]) {
        
        
        CGFloat y = scrollView.contentOffset.y;
        
        if (  y >= self.falseHeaderView.height ) {
           
            self.switchView.y = 0;
            
        } else {
        
            self.switchView.y = -y + self.falseHeaderView.height;

        }

        self.falseHeaderView.y = -y;
        
        
        //有一个上滑到临界点，，其它如果超过临界点，无视，，不到临界点，，滑动到临界点
        if (y <= self.falseHeaderView.height) {
            
            if (self.allTableView.contentOffset.y < self.falseHeaderView.height) {
                [self.allTableView setContentOffset:CGPointMake(0, y)];
            }
            
            //
            if (self.lastTableView.contentOffset.y < self.falseHeaderView.height) {
                [self.lastTableView setContentOffset:CGPointMake(0, y)];
            }
            
            //
            if (self.essenceTableView.contentOffset.y < self.falseHeaderView.height) {
                [self.essenceTableView setContentOffset:CGPointMake(0, y)];
            }
            
        }
        
        //w问题：：：：：解决，有一个下滑，到临界点，其它都滑动到临界点
        if(y == 0) {//三个tableview 到0
            
            [self.allTableView setContentOffset:CGPointMake(0, 0)];
            [self.lastTableView setContentOffset:CGPointMake(0, 0)];
            [self.essenceTableView setContentOffset:CGPointMake(0, 0)];
        
        }
        
    }
    

    
}

- (TLTableView *)tableViewWithFrame:(CGRect)frame  {

    TLTableView *tableView  = [TLTableView tableViewWithframe:frame
                                                    delegate:self
                                                  dataSource:self];
    tableView.rowHeight = 20;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.switchView.height + self.falseHeaderView.height)];
    tableView.tableHeaderView = headerView;
    return tableView;


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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 70;
//
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    v.backgroundColor = [UIColor yellowColor];
//    return v;
//
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 100;
}

//--//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    cell.backgroundColor = RANDOM_COLOR;
    return cell;

}

@end
