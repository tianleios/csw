//
//  CSWDIYPartVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYPartVC.h"
#import "CSWDIYCell.h"

@interface CSWDIYPartVC ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation CSWDIYPartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [collectionView registerClass:[CSWDIYCell class] forCellWithReuseIdentifier:@"id"];
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {


    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CSWDIYCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    
    cell.backgroundColor = RANDOM_COLOR;
    return cell;

}


@end
