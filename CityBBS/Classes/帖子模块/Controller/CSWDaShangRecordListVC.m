//
//  CSWDaShangRecordListVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDaShangRecordListVC.h"
#import "CSWDSRecord.h"
#import "CSWDaShangUserCell.h"

@interface CSWDaShangRecordListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray <CSWDSRecord *>*recordRoom;

@property (nonatomic, strong) TLTableView *tableView;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWDaShangRecordListVC


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    if (self.isFirst) {
        [self.tableView beginRefreshing];
        self.isFirst = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打赏列表";
    
    self.isFirst = YES;
    TLTableView *recordTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:recordTableView];
    
    [recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    recordTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.tableView = recordTableView;
    
    __weak typeof(self) weakSelf = self;
    //
    TLPageDataHelper *pageDataHelper = [TLPageDataHelper new];
    
    pageDataHelper.code = @"610142";
    pageDataHelper.parameters[@"postCode"] =  self.articleCode;
    pageDataHelper.tableView = recordTableView;
    [pageDataHelper modelClass:[CSWDSRecord class]];
    
    //
    [recordTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.recordRoom = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
  
    [recordTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
             weakSelf.recordRoom = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
  
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


     return  self.recordRoom.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWDaShangUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[CSWDaShangUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
     
    }
    
    //
    CSWDSRecord *record = self.recordRoom[indexPath.row];
    cell.userNameLbl.text = record.nickname;
    [cell.userPhoto sd_setImageWithURL:
     [NSURL URLWithString:[record.photo convertThumbnailImageUrl]]];
    
    //
    return cell;

}

@end
