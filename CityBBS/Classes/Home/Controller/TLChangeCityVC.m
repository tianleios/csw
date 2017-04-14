    //
//  TLChangeCityVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLChangeCityVC.h"

@interface TLChangeCityVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, assign) BOOL isSearch;

@end

@implementation TLChangeCityVC

- (void)injected{
    
    [self viewDidLoad];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isSearch = NO;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 7 - 27, SCREEN_WIDTH, 27)];
    [self.navigationController.navigationBar addSubview:barView];
    
    //btn
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 32 - 45, 0, 45, 27)
                                                    title:@"取消"
                                          backgroundColor:[UIColor whiteColor]];
    [cancleBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    [barView addSubview:cancleBtn];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.layer.cornerRadius = 3;
    cancleBtn.layer.borderWidth = 0.5;
    cancleBtn.titleLabel.font = FONT(15);
    cancleBtn.layer.borderColor = [UIColor lineColor].CGColor;
    cancleBtn.layer.masksToBounds = YES;
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(barView.height);
        make.top.equalTo(barView.mas_top);
        make.right.equalTo(barView.mas_right).offset(-8);
    }];
    
 
    //
    UITextField *searchInput = [[UITextField alloc] init];
    [barView addSubview:searchInput];
    searchInput.tintColor = [UIColor themeColor];
    searchInput.placeholder = @"请输入城市名称或首字母";
    searchInput.font = FONT(14);
    searchInput.delegate = self;
    searchInput.returnKeyType = UIReturnKeySearch;
    searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barView.mas_left).offset(40);
        make.right.equalTo(cancleBtn.mas_left).offset(-4);
        make.bottom.equalTo(barView.mas_bottom);
        make.top.equalTo(barView.mas_top);
    }];
    
    
    //
    UIImageView *searchImageV = [[UIImageView alloc] init];
    [barView addSubview:searchImageV];
    searchImageV.backgroundColor = [UIColor whiteColor];
    searchImageV.contentMode = UIViewContentModeCenter;
    searchImageV.image = [UIImage imageNamed:@"choose_city_search"];
    [searchImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barView.mas_left).offset(15);
        make.top.equalTo(barView.mas_top);
        make.height.mas_equalTo(barView.height);
        make.width.mas_equalTo(18);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [barView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(searchImageV.mas_left);
        make.right.equalTo(searchInput.mas_right);
        make.height.mas_equalTo(@(LINE_HEIGHT));
        make.top.equalTo(barView.mas_bottom);
        
    }];

    
    
    //
    UITableView *cityChooseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:cityChooseTableView];
    cityChooseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];

    cityChooseTableView.rowHeight = 30;
    cityChooseTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    cityChooseTableView.delegate = self;
    cityChooseTableView.dataSource = self;
    [cityChooseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)cancle {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [TLProgressHUD showWithStatus:@"站点切换中"];
    NSString *key = [CSWCityManager manager].cityDict.allKeys[indexPath.section];
    CSWCity *city = [CSWCityManager manager].cityDict[key][indexPath.row];
    [[CSWCityManager manager] getCityDetailBy:city success:^{
        
        [TLProgressHUD dismiss];

        //切换成功
        if (self.changeCity) {
            self.changeCity(city);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kCityChangeNotification object:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
    } failure:^{
        
        [TLProgressHUD dismiss];
        [TLProgressHUD showErrorWithStatus:@"切换失败"];
        
    }];
    

    
}


#pragma mark- textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

//
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [CSWCityManager manager].cityDict.allKeys;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString *key = [CSWCityManager manager].cityDict.allKeys[section];
    return [CSWCityManager manager].cityDict[key].count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [CSWCityManager manager].cityDict.allKeys.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.detailTextLabel.x = 25;
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = [UIColor textColor];
        
    }
    
    NSString *key = [CSWCityManager manager].cityDict.allKeys[indexPath.section];
    CSWCity *city = [CSWCityManager manager].cityDict[key][indexPath.row];
    cell.textLabel.text = city.name;
    return cell;

}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];

    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 25, 30) textAligment:NSTextAlignmentLeft backgroundColor:bgView.backgroundColor font:FONT(14) textColor:[UIColor textColor]];
    [bgView addSubview:lbl];
    
    lbl.text = [CSWCityManager manager].cityDict.allKeys[section];

    return bgView;
}




@end
