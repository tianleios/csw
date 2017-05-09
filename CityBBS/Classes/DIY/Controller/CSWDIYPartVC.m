//
//  CSWDIYPartVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYPartVC.h"
#import "CSWDIYCell.h"
#import "CSWVideoModel.h"
#import "MJRefresh.h"
#import "CSWWebVC.h"

@interface CSWDIYPartVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *videCollectionView;
@property (nonatomic, copy) NSArray <CSWVideoModel *>*videos;

@property (nonatomic, assign) BOOL isFirst;


@end

@implementation CSWDIYPartVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        
        [self.videCollectionView.mj_header beginRefreshing];
        self.isFirst = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    [self setUpUI];
    
    //加载头条帖子
    TLPageDataHelper *http = [[TLPageDataHelper alloc] init];
    http.code = @"610055";
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"status"] = @"1";

    [http modelClass:[CSWVideoModel class]];
    
    
    __weak typeof(self) weakSelf = self;
    //刷新事件
    self.videCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [http refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.videos = objs;
            
            [weakSelf.videCollectionView reloadData];
            [weakSelf.videCollectionView.mj_header endRefreshing];
            
            if (!stillHave) {
                
                [weakSelf.videCollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf.videCollectionView.mj_header endRefreshing];
            
        }];
        
    }];
    
    //上拉
    self.videCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [http loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.videos = objs;
            [weakSelf.videCollectionView reloadData];
            if (stillHave) {
                
                [weakSelf.videCollectionView.mj_footer endRefreshing];
                
            } else {
                
                [weakSelf.videCollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            
        } failure:^(NSError *error) {
            
            [weakSelf.videCollectionView.mj_footer endRefreshing];
            
            
        }];
        
    }];
    
    
}

- (void)setUpUI {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 - 10)/2.0, 130);
    
    //
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor backgroundColor];
    self.videCollectionView = collectionView;
    
    //
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
    [collectionView registerClass:[CSWDIYCell class] forCellWithReuseIdentifier:@"id"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {


    return self.videos.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CSWWebVC *webVC = [[CSWWebVC alloc] init];
    webVC.url = self.videos[indexPath.row].url;
    [self.navigationController pushViewController:webVC animated:YES];
    

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CSWDIYCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    
//    cell.backgroundColor = RANDOM_COLOR;
    cell.videoModel = self.videos[indexPath.row];
    return cell;

}


@end
