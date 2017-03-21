//
//  CSWUserDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserDetailVC.h"
#import "CSWUserDetailEditVC.h"

@interface CSWUserDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *navBarImageView;

@property (nonatomic, strong) UIImageView *userPhoto;//用户头像
@property (nonatomic, strong) UILabel *nickNameLbl;//用户昵称 性别，等级
@property (nonatomic, strong) UILabel *focusLbl; //关注
@property (nonatomic, strong) UILabel *fansLbl; //粉丝
@property (nonatomic, strong) UILabel *userIntroduceLbl; //自我介绍

@property (nonatomic, strong) UIImageView *headerImageView;

//底部工具栏
@property (nonatomic, strong) UIView *bootoomTooBar;

//
@property (nonatomic, assign) CGFloat lastAlpha;

@end

@implementation CSWUserDetailVC
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.navBarImageView.alpha = 1;
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.navBarImageView.alpha = self.lastAlpha;

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];


}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.lastAlpha = scrollView.contentOffset.y/150;
    self.navBarImageView.alpha = self.lastAlpha;

}



- (void)injected {

    [self viewDidLoad];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.lastAlpha = 0;
    self.view.backgroundColor = [UIColor orangeColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(goMore)];
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:tableView];
//    tableView.backgroundColor = [UIColor cyanColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-64, 0, -45, 0));
    }];
    
    //headerView
    tableView.tableHeaderView = [self headerView];
    CGFloat h=  [self.nickNameLbl.font lineHeight];
    NSAttributedString *femaleString = [NSAttributedString convertImg:[UIImage imageNamed:@"女"] bounds:CGRectMake(0, -3, h - 2, h - 2)];
    NSMutableAttributedString *nickAttrStr = [[NSMutableAttributedString alloc] initWithString:@"doman" ];
    [nickAttrStr appendAttributedString:femaleString];
    //
    self.nickNameLbl.attributedText = nickAttrStr;
    self.focusLbl.text = @"关注 580";
    self.fansLbl.text = @"粉丝 580";
    self.userIntroduceLbl.text = @"自我介绍";

    
    //底部工具栏--我的直接编写资料
    //
    if (self.type == CSWUserDetailVCTypeMine) { //我的
        
    } else { //其它用户
    
    }
    
    [self.view addSubview:self.bootoomTooBar];
    self.bootoomTooBar.y = SCREEN_HEIGHT - 64 - 45;
    
    
    self.navBarImageView=(UIImageView *)self.navigationController.navigationBar.subviews.firstObject;
//    self.navBarImageView = (UIImageView *)NSClassFromString(@"_UIBarBackground");
    self.navBarImageView.alpha = 0;
}


#pragma mark- 编辑资料
- (void)goEdit {
    
    CSWUserDetailEditVC *editVC =  [[CSWUserDetailEditVC alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark- 关注
- (void)goFouse {


}

#pragma mark- 聊天
- (void)goChat {
    
    
}

-  (UIView *)bootoomTooBar {
    
    if (!_bootoomTooBar) {
        _bootoomTooBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _bootoomTooBar.backgroundColor = [UIColor whiteColor];
        _bootoomTooBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        
        if (self.type == CSWUserDetailVCTypeOther) {
            
        //关注
        UIButton *fouseBtn = [self btnWithFrame:CGRectMake(0, 0, _bootoomTooBar.width/2.0, _bootoomTooBar.height) title:@"关注" imgName:@"关注"];
        [_bootoomTooBar addSubview:fouseBtn];
          [fouseBtn addTarget:self action:@selector(goFouse) forControlEvents:UIControlEventTouchUpInside];
        
        
        //私信
        UIButton *chatBtn = [self btnWithFrame:CGRectMake(fouseBtn.xx, 0, _bootoomTooBar.width/2.0, _bootoomTooBar.height) title:@"私信" imgName:@"私信"];
        [_bootoomTooBar addSubview:chatBtn];
        [chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [_bootoomTooBar addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(@(25));
            make.width.mas_equalTo(1);
            make.center.equalTo(_bootoomTooBar);
        }];
            
        } else {
        //我的
          
            UIButton *chatBtn = [self btnWithFrame:CGRectMake(0, 0, _bootoomTooBar.width, _bootoomTooBar.height) title:@"编辑资料" imgName:@"编辑资料"];
            [_bootoomTooBar addSubview:chatBtn];
            [chatBtn addTarget:self action:@selector(goEdit) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor lineColor];
        [_bootoomTooBar addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bootoomTooBar.mas_left);
            make.width.equalTo(_bootoomTooBar.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.top.equalTo(_bootoomTooBar.mas_top);
        }];
        
    }
    return _bootoomTooBar;
}

- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imageName {
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:frame];
    [chatBtn setTitle:title forState:UIControlStateNormal];
    [chatBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [chatBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    chatBtn.titleLabel.font = FONT(13);
    return chatBtn;
    
}

- (UIImageView *)headerView {
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
                                    
//
    
    self.headerImageView = headerImageView;
    headerImageView.image = [UIImage imageNamed:@"个人详情－背景"];
    
    //
    self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 80, 80)];
    [headerImageView addSubview:self.userPhoto];
    self.userPhoto.layer.cornerRadius = 40;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.centerX = headerImageView.width/2.0;
    self.userPhoto.backgroundColor = [UIColor orangeColor];
    
    //
    self.nickNameLbl = [UILabel labelWithFrame:CGRectMake(0, self.userPhoto.yy + 19, SCREEN_WIDTH, [FONT(15) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(15)
                                     textColor:[UIColor whiteColor]];
    [headerImageView addSubview:self.nickNameLbl];
    
    //关注
    self.focusLbl = [UILabel labelWithFrame:CGRectMake(0, self.nickNameLbl.yy + 23, SCREEN_WIDTH/2.0 - 40, [FONT(15) lineHeight])
                               textAligment:NSTextAlignmentRight
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(15)
                                  textColor:[UIColor whiteColor]];
    [headerImageView addSubview:self.focusLbl];
    
    //粉丝
    self.fansLbl = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2.0 + 40, self.focusLbl.y , self.focusLbl.width, [FONT(15) lineHeight])
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(15)
                                  textColor:[UIColor whiteColor]];
    [headerImageView addSubview:self.fansLbl];
    
    //
    self.userIntroduceLbl = [UILabel labelWithFrame:CGRectMake(20, self.focusLbl.yy  + 18, SCREEN_WIDTH - 40, [FONT(15) lineHeight])
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(15)
                                 textColor:[UIColor whiteColor]];
    self.userIntroduceLbl.numberOfLines = 0;
    [headerImageView addSubview:self.userIntroduceLbl];

    headerImageView.height = self.userIntroduceLbl.yy + 20;
    return headerImageView;
    
}

- (void)data {



}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    cell.backgroundColor = RANDOM_COLOR;
    return cell;
}

- (void)goMore {


}



@end
