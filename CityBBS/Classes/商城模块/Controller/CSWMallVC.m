//
//  CSWMallVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWMallVC.h"
#import "CSWGoodsDetailVC.h"
#import "CSWGoodsCell.h"

@interface CSWMallVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CSWMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赏金商城";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 - 10)/2.0, 100);
    
    //
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor backgroundColor];
    
    //
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
    [collectionView registerClass:[CSWGoodsCell class] forCellWithReuseIdentifier:@"id"];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CSWGoodsDetailVC *detailVC = [[CSWGoodsDetailVC alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    cell.backgroundColor = RANDOM_COLOR;
    return cell;
    
}

@end
