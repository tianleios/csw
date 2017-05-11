//
//  CSWUserDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserDetailVC.h"
#import "CSWUserDetailEditVC.h"
#import "CSWLayoutItem.h"
#import "CSWTimeLineCell.h"
#import "CSWArticleDetailVC.h"
#import "TLUserLoginVC.h"
#import "ChatViewController.h"

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
@property (nonatomic, strong) UIButton *fouseBtn;

//
@property (nonatomic, assign) CGFloat lastAlpha;

@property (nonatomic, strong) TLUser *currentUser;

@property (nonatomic, strong) TLTableView *tableView;
@property (nonatomic, copy) NSArray<CSWLayoutItem *> *layoutItems;

@property (nonatomic, assign) BOOL isFocus;


@end

@implementation CSWUserDetailVC

//
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


//--//
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.lastAlpha = 0;
//    self.view.backgroundColor = [UIColor orangeColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(goMore)];
    
    
    if(self.userId) {
        
        //1.根据userId 获取用户信息
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805256";
        http.parameters[@"userId"] = self.userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            //
            self.currentUser = [TLUser tl_objectWithDictionary:responseObject[@"data"]];
            [self initUI];
            
            [self addGetDataAction];
            [self.tableView beginRefreshing];
            
            //
            [self getRelation];
            
        } failure:^(NSError *error) {
            
        }];
    
    } else if (self.nickName) {
    
        //1.根据userId 获取用户信息
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805255";
        http.parameters[@"nickname"] = self.nickName;
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"1";
        
        [http postWithSuccess:^(id responseObject) {
            
            //
            NSArray *users = responseObject[@"data"][@"list"];
            if (users.count > 0) {
                
                self.currentUser = [TLUser tl_objectWithDictionary:users[0]];
                [self initUI];
                
                //
                [self addGetDataAction];
                [self.tableView beginRefreshing];
                //
                [self getRelation];

            } else {
            
                [TLAlert alertWithError:@"该用户不存在"];
                [self.navigationController popViewControllerAnimated:YES];
            
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    
    } else {
    
        [TLAlert alertWithError:@"必须有id 或者 nickName"];
        [self.navigationController popViewControllerAnimated:YES];
    }
 
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:kUserInfoChange object:nil];
  
}

//--//
- (void)getRelation {

    if ([TLUser user].userId  && ![[TLUser user].userId isEqualToString:self.currentUser.userId]) {
        
        //是否关注了该用户
        TLNetworking *http = [TLNetworking new];
        http.code = @"805092";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"toUser"] = self.currentUser.userId;
        [http postWithSuccess:^(id responseObject) {
            
            NSNumber *isFocus = responseObject[@"data"];
            
            if ([isFocus isEqual:@0]) {
                //未关注
                self.isFocus = NO;
                [self.fouseBtn setTitle:@"关注" forState:UIControlStateNormal];
                
            } else {
                [self.fouseBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                //已关注
                self.isFocus = YES;
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
        //--//
    } else {
        
    }
    
    //--//

}


//--//
- (void)initUI {
    
    if (!self.currentUser) {
        NSLog(@"您还没有获取用户的信息");
        return;
    }
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT - 45) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    
    //    tableView.backgroundColor = [UIColor cyanColor];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, -45, 0));
//    }];
    self.tableView = tableView;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];
    
    //headerView
    tableView.tableHeaderView = [self headerView];
    CGFloat h=  [self.nickNameLbl.font lineHeight];
    NSAttributedString *femaleString = [NSAttributedString convertImg:[UIImage imageNamed:@"女"] bounds:CGRectMake(0, -3, h - 2, h - 2)];
    
    
    NSMutableAttributedString *nickAttrStr = [[NSMutableAttributedString alloc] initWithString:self.currentUser.nickname ];
    [nickAttrStr appendAttributedString:femaleString];
    
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[self.currentUser.userExt.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    self.nickNameLbl.attributedText = nickAttrStr;
    self.focusLbl.text = [NSString stringWithFormat:@"关注 %@",self.currentUser.totalFollowNum];
    
    
    self.fansLbl.text = [NSString stringWithFormat:@"粉丝 %@",self.currentUser.totalFansNum];
    
    if (self.currentUser.userExt.introduce) {
        
        self.userIntroduceLbl.text = self.currentUser.userExt.introduce;

    } else {
        
        self.userIntroduceLbl.text = @"该用户还没有留下自我介绍";

    }
    
    //底部工具栏--我的直接编写资料
    [self.view addSubview:self.bootoomTooBar];
    self.bootoomTooBar.y = SCREEN_HEIGHT - 64 - 45;
    
    self.navBarImageView=(UIImageView *)self.navigationController.navigationBar.subviews.firstObject;
    self.navBarImageView.alpha = 0;

}

#pragma mark- 获取部分数据
- (void)addGetDataAction {

    __weak typeof(self) weakSelf = self;
    
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = ARTICLE_QUERY;
    
    timeLinePageData.parameters[@"publisher"] = self.currentUser.userId;
    timeLinePageData.parameters[@"status"] = @"BD";
    
    timeLinePageData.tableView = self.tableView;
    [timeLinePageData modelClass:[CSWArticleModel class]];
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    
    
    //
    [self.tableView addRefreshAction:^{
        
        [timeLinePageData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [timeLinePageData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
            [weakSelf.tableView  reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
//    [self.tableView addRefreshAction:^{
//        
//    }]
//    TLNetworking *http = [TLNetworking new];
//    http.code = ARTICLE_QUERY;
//    http.parameters[@"userId"] = [TLUser user].userId;
//    http.parameters[@"status"] = @"BD";
//    http.parameters[@"start"] = @"1";
//    http.parameters[@"limit"] = @"10";
//    [http postWithSuccess:^(id responseObject) {
//        
//        NSArray <CSWArticleModel *>articles = [CSWArticleModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
//        [articles ];
//        
//    
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];


}

- (void)userInfoChange {

    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[TLUser user].userExt.photo ] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
    self.nickNameLbl.text = [TLUser user].nickname;

}


#pragma mark- 编辑资料
- (void)goEdit {
    
    CSWUserDetailEditVC *editVC =  [[CSWUserDetailEditVC alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark- 关注
- (void)goFouse {

    
    if (![TLUser user].userId) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    if (self.isFocus) {
        //取消关注
        TLNetworking *unFocusHttp = [TLNetworking new];
        unFocusHttp.showView = self.view;
        unFocusHttp.code = @"805081";
        unFocusHttp.parameters[@"userId"] = [TLUser user].userId;
        unFocusHttp.parameters[@"token"] = [TLUser user].token;
        unFocusHttp.parameters[@"toUser"] = self.currentUser.userId;
        //
        [unFocusHttp postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithInfo:@"成功取消关注"];
            [self.fouseBtn setTitle:@"关注" forState:UIControlStateNormal];
            self.isFocus = NO;
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        //关注
        //关注用户
        TLNetworking *focusHttp = [TLNetworking new];
        focusHttp.showView = self.view;
        focusHttp.code = @"805080";
        focusHttp.parameters[@"userId"] = [TLUser user].userId;
        focusHttp.parameters[@"token"] = [TLUser user].token;
        focusHttp.parameters[@"toUser"] = self.currentUser.userId;
        //
        [focusHttp postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithInfo:@"关注成功"];
            [self.fouseBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            self.isFocus = YES;
            
        } failure:^(NSError *error) {
            
        }];
        
    //--//
    }

}

#pragma mark- 聊天
- (void)goChat {
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:self.currentUser.userId conversationType:EMConversationTypeChat];
    chatVC.defaultUserAvatarName = @"avatar_default_small";
    
    chatVC.oppositeAvatarUrlPath = self.currentUser.userExt.photo ?  [self.currentUser.userExt.photo convertThumbnailImageUrl] : nil;
    chatVC.mineAvatarUrlPath = [TLUser user].userExt.photo ? [[TLUser user].userExt.photo convertThumbnailImageUrl] : nil;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

-  (UIView *)bootoomTooBar {
    
    if (!_bootoomTooBar) {
        _bootoomTooBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _bootoomTooBar.backgroundColor = [UIColor whiteColor];
        _bootoomTooBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        //1.用户为登录
        
        
        if (![TLUser user].userId || ![[TLUser user].userId isEqualToString:self.userId]) {
            
        //关注
        UIButton *fouseBtn = [self btnWithFrame:CGRectMake(0, 0, _bootoomTooBar.width/2.0, _bootoomTooBar.height) title:@"关注" imgName:@"关注"];
        [_bootoomTooBar addSubview:fouseBtn];
        self.fouseBtn = fouseBtn;
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //计算
    //    return  self.layoutItem.cellHeight;
    return self.layoutItems[indexPath.row].cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    layoutItem.article = self.layoutItems[indexPath.row].article;
    //
    //    detailVC.layoutItem = layoutItem;
    detailVC.articleCode = layoutItem.article.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.layoutItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
        
    }
    
    
    //    cell.layoutItem = self.layoutItem;
    cell.layoutItem = self.layoutItems[indexPath.row];
    return cell;
    
    
    
}

- (void)goMore {


}



@end
