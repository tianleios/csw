//
//  CSWMoneyRewardFlowVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWMoneyRewardFlowVC.h"
#import "CSWMallVC.h"
#import "CSWSJRuleVC.h"
#import "CSWSJCell.h"
#import "CSWAccountFlowModel.h"

@interface CSWMoneyRewardFlowVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *flowTableView;
@property (nonatomic, copy) NSArray <CSWAccountFlowModel *> *flowModels;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWMoneyRewardFlowVC


- (void)viewWillAppear:(BOOL)animated {


    [super viewWillAppear:animated];
    if (self.isFirst) {
        
        self.isFirst = NO;
        [self.flowTableView beginRefreshing];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赏金详情";
    
    self.isFirst = YES;
    
    //赏金商城
    UIButton *goMallBtn = [self btnWithFram:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 60) imgName:@"mine_积分商城" title:@"积分商城"];
    [self.view addSubview:goMallBtn];
    [goMallBtn addTarget:self action:@selector(goMall) forControlEvents:UIControlEventTouchUpInside];
    
    //如何赚赏金
    UIButton *sjBtn = [self btnWithFram:CGRectMake(goMallBtn.right, 0, SCREEN_WIDTH/2.0, 60) imgName:@"赚赏金" title:@"如何赚赏金"];
    [self.view addSubview:sjBtn];
    [sjBtn addTarget:self action:@selector(goSJ) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goMallBtn.mas_right);
        make.width.equalTo(@1);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(goMallBtn.mas_centerY);
    }];
    
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    self.flowTableView = tableView;
    [self.view addSubview:tableView];
    
    
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    tableView.rowHeight = 45;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(70, 0, 0, 0));
    }];

    
    TLPageDataHelper *pageDateHelper = [[TLPageDataHelper alloc] init];
    pageDateHelper.code = @"802524";
    pageDateHelper.tableView = self.flowTableView;
    //
    pageDateHelper.parameters[@"userId"] = [TLUser user].userId;
    pageDateHelper.parameters[@"token"] = [TLUser user].token;
//  accountNumber = A2017050812285008914;
    
    
    
    pageDateHelper.parameters[@"accountNumber"] = self.accountNumber;
    
    
  [pageDateHelper modelClass:[CSWAccountFlowModel class]];
    
    //--//
    __weak typeof(self) weakself = self;
    [self.flowTableView addRefreshAction:^{
        
        [pageDateHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.flowModels = objs;
            [weakself.flowTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    [self.flowTableView addLoadMoreAction:^{
        
        [pageDateHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
//          weakself.users = objs;
            weakself.flowModels = objs;
            [weakself.flowTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    
}


//--//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.flowModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWSJCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSJCellID"];
    if (!cell) {
        
        cell = [[CSWSJCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSJCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.flowModel = self.flowModels[indexPath.row];
    return cell;

}


- (void)goMall {

    CSWMallVC *mallVC = [[CSWMallVC alloc] init];
    [self.navigationController pushViewController:mallVC animated:YES];

}

- (void)goSJ {

    CSWSJRuleVC *sjRullVC = [[CSWSJRuleVC alloc] init];
    [self.navigationController pushViewController:sjRullVC animated:YES];
}



- (UIButton *)btnWithFram:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title {

    UIButton *goMallBtn = [[UIButton alloc] initWithFrame:frame];
    goMallBtn.titleLabel.font = FONT(15);
    [goMallBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    goMallBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    goMallBtn.backgroundColor = [UIColor whiteColor];
    [goMallBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [goMallBtn setTitle:title forState:UIControlStateNormal];
    return goMallBtn;
}



@end
