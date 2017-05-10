//
//  TLHomeVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHomeVC.h"
#import "TLGroupItem.h"
#import "TLComposeVC.h"
#import "TLDisplayBannerCell.h"
#import "TLFunc3Cell.h"
#import "TLFunc8Cell.h"
#import "TLArticleCell.h"

#import "TLChangeCityVC.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import "CSWMallVC.h"
#import "CSWSearchVC.h"
#import "CSWCityManager.h"
#import "MJRefresh.h"
#import "CSWArticleModel.h"
#import "CSWArticleDetailVC.h"

@interface TLHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *homeCollectionView;
@property (nonatomic, strong) NSMutableArray <TLGroupItem *>*groups;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UILabel *currentCityLbl;
@property (nonatomic, copy) NSArray <CSWArticleModel *> *headlineArticles;
@property (nonatomic, strong) TLPageDataHelper *homeHeadlineArticlePageData;


@property (nonatomic, assign) BOOL isFirst;

@end


@implementation TLHomeVC

- (UIView *)titleBtn {

    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
        
        UILabel *titlelbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(18)
                                          textColor:[UIColor whiteColor]];
        [_titleBtn addSubview:titlelbl];
        self.currentCityLbl = titlelbl;
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleBtn.mas_centerX);
            make.bottom.equalTo(_titleBtn.mas_bottom).offset(-4);
            
        }];
        titlelbl.text = @"青田城市网";
        
        //
        UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headline_location_arrow"]];
        [_titleBtn addSubview:arrawView];
        [arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titlelbl.mas_right).offset(7);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(8);
            make.centerY.equalTo(titlelbl.mas_centerY);
        }];
        
    }
    return _titleBtn;

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {
        [self.homeCollectionView.mj_header beginRefreshing];
        self.isFirst = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.isFirst = YES;
    
    
    //left-search
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"headline_search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //right-send
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
    //顶部切换
    self.navigationItem.titleView = self.titleBtn;
    [self.titleBtn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];

    //UI
    [self setUpUI];
    
    //当前城市
    self.currentCityLbl.text = [CSWCityManager manager].currentCity.name;
    
    
    
    //加载头条帖子
    TLPageDataHelper *homeData = [[TLPageDataHelper alloc] init];
    homeData.code = ARTICLE_QUERY;
    homeData.parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
    [homeData modelClass:[CSWArticleModel class]];
    self.homeHeadlineArticlePageData = homeData;
    
    
    __weak typeof(self) weakSelf = self;
    //刷新事件
    self.homeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [homeData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.headlineArticles = objs;
            [weakSelf.homeCollectionView reloadData];
            [weakSelf.homeCollectionView.mj_header endRefreshing];
            
            if (!stillHave) {
                
                [weakSelf.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf.homeCollectionView.mj_header endRefreshing];
            
        }];
        
    }];
    
    //上拉
    self.homeCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [homeData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.headlineArticles = objs;
            [weakSelf.homeCollectionView reloadData];
            if (stillHave) {
                
                [weakSelf.homeCollectionView.mj_footer endRefreshing];
                
            } else {
                
                [weakSelf.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            
        } failure:^(NSError *error) {
            
            [weakSelf.homeCollectionView.mj_footer endRefreshing];
            
            
        }];
        
    }];
  
  
 
}


- (void)setUpUI {

    [self.view addSubview:self.homeCollectionView];
    
    self.homeCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 -64);
    
//    [self.homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    //注册cell
    [self.homeCollectionView registerClass:[TLDisplayBannerCell class] forCellWithReuseIdentifier:[TLDisplayBannerCell reuseId]];
    [self.homeCollectionView registerClass:[TLFunc3Cell class] forCellWithReuseIdentifier:[TLFunc3Cell reuseId]];
    [self.homeCollectionView registerClass:[TLFunc8Cell class] forCellWithReuseIdentifier:[TLFunc8Cell reuseId]];
    [self.homeCollectionView registerClass:[TLArticleCell class] forCellWithReuseIdentifier:[TLArticleCell reuseId]];
    
    
    //
    //显示模型
    self.groups = [[NSMutableArray alloc] init];
    
    //头
    TLGroupItem *bannerItem = [TLGroupItem new];
    bannerItem.itemSize = CGSizeMake(self.homeCollectionView.width, 180);
    bannerItem.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    bannerItem.cellNumber = 1;
    bannerItem.minimumLineSpacing = 0;
    bannerItem.minimumInteritemSpacing = 0;
    bannerItem.cellClass = [TLDisplayBannerCell class];
    
    //3功能
    TLGroupItem *func3Item = [TLGroupItem new];
    func3Item.itemSize = CGSizeMake((self.homeCollectionView.width - 32)/3.0, 40);
    func3Item.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    func3Item.cellNumber = 3;
    func3Item.minimumLineSpacing = 6;
    func3Item.minimumInteritemSpacing = 0;
    func3Item.cellClass = [TLFunc3Cell class];
    
    //func8
    TLGroupItem *func8Item = [TLGroupItem new];
    func8Item.itemSize = CGSizeMake((self.homeCollectionView.width - 32)/4.0, 72);
    func8Item.edgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    func8Item.cellNumber = 8;
    func8Item.minimumLineSpacing = 4;
    func8Item.minimumInteritemSpacing = 4;
    func8Item.cellClass = [TLFunc8Cell class];
    
    //headLineItem
    TLGroupItem *headLineItem = [TLGroupItem new];
    headLineItem.itemSize = CGSizeMake(self.homeCollectionView.width - 20, 90);
    headLineItem.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    headLineItem.cellNumber = 8;
    headLineItem.minimumLineSpacing = 0;
    headLineItem.minimumInteritemSpacing = 0;
    headLineItem.cellClass = [TLArticleCell class];
    
    [self.groups addObjectsFromArray:@[bannerItem,func3Item,func8Item,headLineItem]];
    
    
}
#pragma mark- 切换城市
- (void)changeCity {

    //先获取城市列表
    [[CSWCityManager manager] getCityListSuccess:^{
        
        TLChangeCityVC *changeCityVC = [[TLChangeCityVC alloc] init];
        changeCityVC.changeCity = ^(CSWCity *city){
            
            //切换成功
            [CSWCityManager manager].currentCity = city;
            self.currentCityLbl.text = [CSWCityManager manager].currentCity.name;
            
            //--//
            self.homeHeadlineArticlePageData.parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
            
            //--//
            [self.homeCollectionView.mj_header beginRefreshing];
//          [self.homeCollectionView reloadData];
            
        };
        
        //--//
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:changeCityVC];
        nav.navigationBar.barTintColor = [UIColor whiteColor];
        nav.navigationBar.barStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } failure:^{
        
        
    }];
  
}

#pragma mark- 用户 帖子搜索
- (void)search {

    CSWSearchVC *searchVC = [CSWSearchVC new];
    [self.navigationController pushViewController:searchVC animated:YES];
    
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

#pragma mark- collectionView --- delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = nil;
    switch (indexPath.section) {
        case 1: {
            
          url = [CSWCityManager manager].func3Room[indexPath.row].url;
        
        } break;
        
        case 2: {
          
          //
          url = [CSWCityManager manager].func8Room[indexPath.row].url;

        } break;
           
        case 3: {//跳帖子详情
            CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
            detailVC.articleCode = self.headlineArticles[indexPath.row].code;
            [self.navigationController pushViewController:detailVC animated:YES];
        
        //
        } break;
            
    }
    
    //
    if (url) {
        //:内部也
        [CSWCityManager jumpWithUrl:url navCtrl:self.navigationController parameters:nil signin:^{
            //如果是签到，将调用该
            if ([TLUser user].userId) {
                //
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"805100";
                http.parameters[@"userId"] = [TLUser user].userId;
                http.parameters[@"token"] = [TLUser user].token;
                [http postWithSuccess:^(id responseObject) {
         
                    //
                    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.80];
                    [maskCtrl addTarget:self action:@selector(removeMask:) forControlEvents:UIControlEventTouchUpInside];
                    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
                    
                    //
                    UIImageView *suceeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
                    suceeImageView.contentMode = UIViewContentModeScaleAspectFit;
                    suceeImageView.image = [UIImage imageNamed:@"签到成功"];
                    [maskCtrl addSubview:suceeImageView];
                    suceeImageView.centerX = maskCtrl.width/2.0;
                    suceeImageView.centerY = maskCtrl.height/2.0 - 50;
                    
                    //
                    UILabel *hintLbl = [[UILabel alloc] init];
                    hintLbl.numberOfLines = 0;
                    hintLbl.textAlignment = NSTextAlignmentCenter;
                    hintLbl.textColor = [UIColor whiteColor];
                    [maskCtrl addSubview:hintLbl];
                    hintLbl.font = FONT(15);
                    
                    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(maskCtrl);
                        make.top.equalTo(suceeImageView.mas_bottom).offset(5);
                    }];
                    
                    NSNumber *amount = responseObject[@"data"][@"amount"];
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜你今天获得\n%@赏金",[amount convertToSimpleRealMoney]]];
                    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(8, [amount convertToSimpleRealMoney].length)];
                    hintLbl.attributedText = attr;
                    
                    
                    ///---//
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [maskCtrl removeFromSuperview];
                        
                        
                    });
                    
                    
                    
                } failure:^(NSError *error) {
                  
                    
                }];

            } else {
            
                TLNavigationController *navCtrl = [[TLNavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
                [self presentViewController:navCtrl animated:YES completion:nil];
            
            }
            
        }];
        
    }


}

//
- (void)removeMask:(UIControl *)ctrl {

    [ctrl removeFromSuperview];

}


- (UICollectionView *)homeCollectionView {

    if (!_homeCollectionView) {
        
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
        
        //布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        //
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _homeCollectionView.delegate = self;
        _homeCollectionView.backgroundColor = [UIColor whiteColor];
        _homeCollectionView.dataSource = self;
        _homeCollectionView.showsVerticalScrollIndicator = NO;

    }
    
    return _homeCollectionView;

}



#pragma mark- datasourcce
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            __weak typeof(self) weakSelf = self;
         TLDisplayBannerCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TLDisplayBannerCell reuseId] forIndexPath:indexPath];
         cell.bannerRoom = [CSWCityManager manager].bannerRoom;
            
          //处理跳转
         [cell.bannerView setSelected:^(NSInteger idx){
             
//             NSLog(@"%ld",idx);
             [CSWCityManager jumpWithUrl:[CSWCityManager manager].bannerRoom[idx].url navCtrl:weakSelf.navigationController parameters:nil signin:nil];
             ;
             
         }];
         return cell;
        
        }
        break;
            
        case 1: {
            
            TLFunc3Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TLFunc3Cell reuseId] forIndexPath:indexPath];
            cell.funcModel = [CSWCityManager manager].func3Room[indexPath.row];
            return cell;
            
        }
        break;
            
        case 2: {
            
            TLFunc8Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TLFunc8Cell reuseId] forIndexPath:indexPath];
            cell.funcModel = [CSWCityManager manager].func8Room[indexPath.row];
            return cell;
            
        }
        break;
            
        default: {
            
            TLArticleCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TLArticleCell reuseId] forIndexPath:indexPath];
            cell.articleModel = self.headlineArticles[indexPath.row];
            return cell;
            
        }
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 3) { //头条文章
        
        return self.headlineArticles.count;
        
    }
    
    //
    return  self.groups[section].cellNumber;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.groups[section].edgeInsets;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return  self.groups.count;
}

#pragma mark- flowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.groups[indexPath.section].itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.groups[section].minimumLineSpacing;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.groups[section].minimumInteritemSpacing;
    
}

@end
