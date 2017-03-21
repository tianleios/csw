//
//  CSWSearchVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSearchVC.h"
#import "CSWUserDetailVC.h"
#import "CSWFansCell.h"
#import "CSWTimeLineCell.h"
#import "CSWArticleDetailVC.h"

@interface CSWSearchVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL isSearchUser;


@end

@implementation CSWSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"用户",@"帖子"]];
    segment.width = 160;
    self.navigationItem.titleView = segment;
    segment.selectedSegmentIndex = 0;
    self.isSearchUser = YES;
//    segment.backgroundColor = [UIColor whiteColor];
    
//    segment.tintColor = [UIColor themeColor];
    
    
    TLTableView *fansTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    fansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansTableView];
    [fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    searchBgView.backgroundColor = [UIColor whiteColor];
    fansTableView.tableHeaderView = searchBgView;
    
    CSWSearchTf *searchTf = [[CSWSearchTf alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30 , searchBgView.height - 20)];
    [searchBgView addSubview:searchTf];
    searchTf.layer.cornerRadius = searchTf.height/2.0;
    searchTf.layer.masksToBounds = YES;
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTf.placeholder = @"请输入搜索内容";
    searchTf.backgroundColor = [UIColor backgroundColor];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [searchBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBgView.mas_left);
        make.width.equalTo(searchBgView.mas_width);
        make.height.mas_equalTo(@(LINE_HEIGHT));
        make.bottom.equalTo(searchBgView.mas_bottom);
    }];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchUser) {
        
        CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
        userDetailVC.type = CSWUserDetailVCTypeOther;
        [self.navigationController pushViewController:userDetailVC animated:YES];
        
    } else {
    
        CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchUser) {
        
        CSWFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWFansCellID"];
        if (!cell) {
            
            cell = [[CSWFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWFansCellID"];
            
        }
        
        return cell;
    }
    
    //
    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCellID"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCellID"];
        
    }
    
    return cell;

    
}

@end


@implementation CSWSearchTf

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
//
//    
//    
//    CGRect newRect = bounds;
////    newRect.origin.x = newRect.origin.x + 1;
//    return newRect;
//
//}


- (CGRect)newRect:(CGRect)oldRect {
    
    CGRect newRect = oldRect;
    newRect.origin.x = newRect.origin.x + 20;
    return newRect;
}
@end


