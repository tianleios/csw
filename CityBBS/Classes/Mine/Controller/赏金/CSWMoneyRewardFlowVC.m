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

@interface CSWMoneyRewardFlowVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CSWMoneyRewardFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赏金详情";
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
    [self.view addSubview:tableView];
    tableView.rowHeight = 45;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(70, 0, 0, 0));
    }];

    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWSJCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSJCellID"];
    if (!cell) {
        
        cell = [[CSWSJCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSJCellID"];
        
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
