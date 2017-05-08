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
#import "CSWCityManager.h"
#import "SVProgressHUD.h"

@interface TLHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *homeCollectionView;
@property (nonatomic, strong) NSMutableArray <TLGroupItem *>*groups;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UILabel *currentCityLbl;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
 
    self.navigationController.tabBarItem.badgeValue = @"10";
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
    
    
    [[CSWCityManager manager] getCityListSuccess:^{
        
        
        
    } failure:^{
        
        
    }];


}
#pragma mark- 切换城市
- (void)changeCity {

    TLChangeCityVC *changeCityVC = [[TLChangeCityVC alloc] init];
    changeCityVC.changeCity = ^(CSWCity *city){
    
        [CSWCityManager manager].currentCity = city;
        self.currentCityLbl.text = [CSWCityManager manager].currentCity.name;
        [self.homeCollectionView reloadData];
        
    };
    //--//
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:changeCityVC];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    nav.navigationBar.barStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];

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

    [TLProgressHUD showWithStatus:@"正在定位中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];
        
    });
    
    return;
    if (indexPath.section == 1) {
        CSWMallVC *mallVC = [[CSWMallVC alloc] init];
        [self.navigationController pushViewController:mallVC animated:YES];
    }

}

- (void)injected {

    [self.homeCollectionView reloadData];

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
            
         TLDisplayBannerCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TLDisplayBannerCell reuseId] forIndexPath:indexPath];
         cell.bannerRoom = [CSWCityManager manager].bannerRoom;
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
            return cell;
            
        }
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
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
