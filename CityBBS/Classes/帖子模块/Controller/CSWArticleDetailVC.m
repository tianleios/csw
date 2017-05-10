//
//  CSWArticleDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleDetailVC.h"
#import "CSWTimeLineCell.h"
#import "CSWDaShangCell.h"
#import "CSWUserActionSwitchView.h"
#import "CSWCommentCell.h"
#import "CSWCommentLayoutItem.h"
#import "CSWDZCell.h"

#import "CSWArticleDetailToolBarView.h"
#import "CSWSendCommentVC.h"
#import "TLUserLoginVC.h"
#import "CSWArticleApi.h"
#import "CSWReportVC.h"
#import "CSWDSRecord.h"
#import "CSWDaShangRecordListVC.h"

#define USER_ACTION_SWITCH_HEIGHT 40
#define SJ_CELL_HEIGHT 80
#define COMMENT_INPUT_VIEW_HEIGHT 49


@interface CSWArticleDetailVC ()<UITableViewDelegate,UITableViewDataSource,CSWUserActionSwitchDelegate,ArticleDetailToolBarViewDelegate>

//@property (nonatomic, strong) CSWCommentInputView *commentInputView;
@property (nonatomic, strong) CSWArticleDetailToolBarView *toolBarView;


@property (nonatomic, strong) NSMutableArray <CSWCommentLayoutItem *> *commentLayoutItems;
@property (nonatomic, strong) NSMutableArray <CSWLikeModel *>*dzModels;

@property (nonatomic, assign) BOOL isComment;

//重新设计
@property (nonatomic, strong) UIScrollView  *bgScrollView; //背景
@property (nonatomic, strong) CSWUserActionSwitchView *userActionSwitchView; //切换卡

@property (nonatomic, strong) TLTableView *articleDetailTableView; //显示帖子详情 + 赏金


@property (nonatomic, strong) TLTableView *commentTableView; //评论
@property (nonatomic, strong) TLTableView *dzTableView; //点赞


@property (nonatomic, strong) CSWLayoutItem *layoutItem;

@property (nonatomic, assign) CGFloat articleDetailTableViewHeigth;
@property (nonatomic, strong) UIView *commentHeaderView;
@property (nonatomic, strong) UIView *dzHeaderView;

@property (nonatomic, strong) CSWCommentModel *currentOperationComment;

@property (nonatomic, strong) NSMutableArray <CSWDSRecord *>*dsRecordRoom;

@end

@implementation CSWArticleDetailVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<CSWDSRecord *> *)dsRecordRoom {

    if (!_dsRecordRoom) {
        
        _dsRecordRoom = [NSMutableArray array];
    }
    return _dsRecordRoom;

}

- (NSMutableArray<CSWCommentLayoutItem *> *)commentLayoutItems {

    if (!_commentLayoutItems) {
        
        _commentLayoutItems = [NSMutableArray new];
        
    }
    
    return _commentLayoutItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子详情";
    
    self.isComment = YES;
    
    if (!self.articleCode) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //0.增加帖子阅读量
    TLNetworking *readNumHttp = [TLNetworking new];
    readNumHttp.code = @"610120";
    readNumHttp.parameters[@"postCode"] = self.articleCode;
    [readNumHttp postWithSuccess:nil failure:nil];

    
    [self getArticleDetailData];


}

#pragma mark- 获取帖子详情
- (void)getArticleDetailData {

    //1.根据code获取帖子信息
    [TLProgressHUD showWithStatus:@"加载中...."];
    TLNetworking *getArticleHttp = [TLNetworking new];
    getArticleHttp.code = @"610132";
    getArticleHttp.parameters[@"code"] = self.articleCode;
    getArticleHttp.parameters[@"userId"] = [TLUser user].userId ? : nil;
    
    [getArticleHttp postWithSuccess:^(id responseObject) {
        
        //移除可能失败的重新加载站位
        [self.tl_placeholderView removeFromSuperview];
        
        //
        CSWArticleModel *articleModel = [CSWArticleModel tl_objectWithDictionary:responseObject[@"data"]];
        self.layoutItem = [[CSWLayoutItem alloc] init];
        self.layoutItem.type = CSWArticleLayoutTypeArticleDetail;
        self.layoutItem.article = articleModel;
        
        //UI
        [self setUpUI];
        
        //评论点赞数据
        self.userActionSwitchView.countStrRoom = @[[self.layoutItem.article.sumComment stringValue],[self.layoutItem.article.sumLike stringValue]];
        
        [TLProgressHUD dismiss];
        
        //获取打赏，评论 ，点在数据
        [self getData];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        //        [TLAlert alertWithError:@"加载失败"];
        
        [self tl_placholderViewWithTitle:@"加载失败" opTitle:@"重新加载"];
        [self.view addSubview:self.tl_placeholderView];
        
    }];

}


#pragma mark- 重新加载方法
- (void)tl_placeholderOperation {

    [self getArticleDetailData];
    
}


//--//
- (void)getData {

    //获取评论
    TLNetworking *http = [TLNetworking new];
    //    http.showView = self.view;
    http.code = @"610133";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"100";
    //    http.parameters[@"status"] = @"D";
    http.parameters[@"postCode"] = self.layoutItem.article.code;
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr =  responseObject[@"data"][@"list"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CSWCommentModel *commentModel = [CSWCommentModel tl_objectWithDictionary:obj];
            CSWCommentLayoutItem *layoutItem = [CSWCommentLayoutItem new];
            layoutItem.commentModel = commentModel;
            //
            [self.commentLayoutItems addObject:layoutItem];
            //            [self.articleDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (self.commentLayoutItems.count) {
                
                [self.commentTableView reloadData];

            }
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
    //获取点赞
    TLNetworking *dzHttp = [TLNetworking new];
    //    dzHttp.showView = self.view;
    dzHttp.code = @"610141";
    dzHttp.parameters[@"start"] = @"1";
    dzHttp.parameters[@"limit"] = @"10";
    dzHttp.parameters[@"userId"] = self.layoutItem.article.publisher;
    dzHttp.parameters[@"postCode"] = self.layoutItem.article.code;
    [dzHttp postWithSuccess:^(id responseObject) {
        
        self.dzModels = [CSWLikeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        
        if(self.dzModels.count) {
            
            [self.dzTableView reloadData];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    //打赏
    TLNetworking *dsRecordHttp = [TLNetworking new];
    dsRecordHttp.showView = self.view;
    dsRecordHttp.code = @"610142";
    dsRecordHttp.parameters[@"postCode"] = self.layoutItem.article.code;
    dsRecordHttp.parameters[@"start"] = @"1";
    dsRecordHttp.parameters[@"limit"] = @"20";
    [dsRecordHttp postWithSuccess:^(id responseObject) {
        
        //
        self.dsRecordRoom = [CSWDSRecord tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        //
        [self.articleDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:0];
        //
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark- 底部工具栏代理
- (void)didSelectedAction:(CSWArticleDetailToolBarView *)toolBarView action:(CSWArticleDetailToolBarActionType) actionType {

    if (![TLUser user].userId) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    
        return;
    }
    
    switch (actionType) {
            
            case  CSWArticleDetailToolBarActionTypeSendCompose : {
            
                //对帖子进行评论
                CSWSendCommentVC *sendCommentVC = [[CSWSendCommentVC alloc] init];
                sendCommentVC.type =  CSWSendCommentActionTypeToArticle;
                sendCommentVC.toObjCode = self.articleCode;
                [sendCommentVC setCommentSuccess:^(CSWCommentModel *model){
                    
                    CSWCommentLayoutItem *layoutItem = [[CSWCommentLayoutItem alloc] init];
                    layoutItem.commentModel = model;
                    
                    [self.commentLayoutItems insertObject:layoutItem atIndex:0];
                    [self.commentTableView reloadData_tl];
                    
                    //评论数据增加
                    self.layoutItem.article.sumComment = @([self.layoutItem.article.sumComment longLongValue] + 1);
                    self.userActionSwitchView.countStrRoom = @[[self.layoutItem.article.sumComment stringValue] ,[self.layoutItem.article.sumLike stringValue]];
                    
                }];
                //
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendCommentVC];
                [self presentViewController:nav animated:YES completion:nil];
                
            }
            break;
            
            case  CSWArticleDetailToolBarActionTypeDZ : {//点赞
                
                //是否已经点赞
                //取消和点赞
                [toolBarView dzSuccess];
                
                [CSWArticleApi dzArticleWithCode:self.articleCode
                                        user:[TLUser user].userId
                                         success:^{
                                             
                                         }
                                         failure:^{
                                             
                                             [toolBarView dzFailure];
                                             
                                         }];
                
            }
            break;
            
            case  CSWArticleDetailToolBarActionTypeCollection : {//收藏
                
                [CSWArticleApi collectionArticleWithCode:self.articleCode
                                            user:[TLUser user].userId
                                         success:^{
                                             [TLAlert alertWithSucces:@"收藏成功"];
                                         }
                                         failure:^{
                                             
                                         }];
                
            }
            break;
            
            case  CSWArticleDetailToolBarActionTypeReport: {//举报
                
                CSWReportVC *vc = [CSWReportVC new];
                vc.reportObjCode = self.articleCode;
                [self.navigationController pushViewController:vc animated:YES];
             
            }
            break;

    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![TLUser user].userId) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
        return;
    }
    
    //打赏
    if ([tableView isEqual:self.articleDetailTableView] && indexPath.section == 1) {
    
        
        
        //打赏行为
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"请输入打赏金额" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"打赏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![alertCtrl.textFields[0].text valid]) {
                
                [TLAlert alertWithInfo:@"请输入打赏金额"];
                return ;
            }
          
            [TLProgressHUD showWithStatus:nil];
            [CSWArticleApi dsArticleWithCode:self.articleCode
                                        user:[TLUser user].userId
                                       money:[alertCtrl.textFields[0].text floatValue]
                                     success:^{
                                         
                                         [alertCtrl dismissViewControllerAnimated:YES completion:nil];
                                         [TLProgressHUD dismiss];
                                         [TLAlert alertWithSucces:@"打赏成功"];
                                         
                                         //刷新界面
                                         CSWDSRecord *recoerd = [[CSWDSRecord alloc] init];
                                         recoerd.nickname = [TLUser user].nickname;
                                         recoerd.photo = [TLUser user].userExt.photo;

                                         [self.dsRecordRoom insertObject:recoerd atIndex:0];
                                         [self.articleDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:0];

                                     } failure:^{
                                         [TLProgressHUD dismiss];

                                     }];
            
            
        }];
        
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCtrl addAction:cancleAction];
        [alertCtrl addAction:confirmAction];
    
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
        return;
    }

    if (![tableView isEqual:self.commentTableView]) {
        return;
    }
    
    self.currentOperationComment = self.commentLayoutItems[indexPath.row].commentModel;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self becomeFirstResponder];
    
    UIMenuController *mentCtrl = [UIMenuController sharedMenuController];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"评论" action:@selector(comment:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];

    mentCtrl.menuItems = @[item1,item2];
    [mentCtrl setTargetRect:CGRectInset(cell.frame, 0, 40) inView:cell.superview];
    [mentCtrl setMenuVisible:YES animated:YES];


}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(comment:)){
        
        
        return YES;
        
    }else if (action==@selector(report:)){
        
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}


#pragma mark- 对评论进行评论
- (void)comment:(id)sender {

    
            CSWCommentModel *model =  self.currentOperationComment;
    
            //对帖子进行评论
            CSWSendCommentVC *sendCommentVC = [[CSWSendCommentVC alloc] init];
            sendCommentVC.type =  CSWSendCommentActionTypeToComment;
            sendCommentVC.toObjCode = model.code
            ;
            sendCommentVC.toObjNickName = model.commentUserNickname;
    
            [sendCommentVC setCommentSuccess:^(CSWCommentModel *model){
    
                CSWCommentLayoutItem *layoutItem = [[CSWCommentLayoutItem alloc] init];
                layoutItem.commentModel = model;
    
                [self.commentLayoutItems insertObject:layoutItem atIndex:0];
                [self.commentTableView reloadData_tl];
    
            }];
            //
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendCommentVC];
            [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark- 举报 评论
- (void)report:(id)sender {

    CSWReportVC *vc = [CSWReportVC new];
    vc.isReportComment = YES;
    vc.reportObjCode = self.currentOperationComment.code;
    [self.navigationController pushViewController:vc animated:YES];
  
}


//必须要有，如果要UIMenuController显示
-(BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ([self.bgScrollView isEqual:scrollView]) {
        return;
    }

    //
    if ([scrollView isEqual:self.commentTableView]) {
        
        //两个内容同步
        self.dzTableView.contentOffset = scrollView.contentOffset;
        
        
        if(scrollView.contentOffset.y > 0 ) {
        
            //1............
            if (scrollView.contentOffset.y > self.articleDetailTableViewHeigth) {
            
                 self.userActionSwitchView.y = scrollView.contentOffset.y;
            } else {
            
                self.userActionSwitchView.y = self.articleDetailTableViewHeigth;

            }
            
        }
        
    } else {
    
        //两个内容同步
        self.commentTableView.contentOffset = scrollView.contentOffset;
        
        
        if(scrollView.contentOffset.y > 0 ) {
            
            //1.
            if (scrollView.contentOffset.y > self.articleDetailTableViewHeigth) {
                
                self.userActionSwitchView.y = scrollView.contentOffset.y;
            } else {
                
                self.userActionSwitchView.y = self.articleDetailTableViewHeigth;
                
            }
        }
    }
    

}

- (void)setUpUI {

    //帖子高度 + 赏金cell高度 + 间隔
    CGFloat articleDetailTableViewHeight = _layoutItem.cellHeight + SJ_CELL_HEIGHT + 20;
    self.articleDetailTableViewHeigth = articleDetailTableViewHeight;
    
    
    //1.背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - COMMENT_INPUT_VIEW_HEIGHT)];
    self.bgScrollView.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.delegate = self;
    
    //底部工具栏
    self.toolBarView = [[CSWArticleDetailToolBarView alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, SCREEN_WIDTH, COMMENT_INPUT_VIEW_HEIGHT)];
    self.toolBarView.delegate = self;
    [self.view addSubview:self.toolBarView];

    //6.帖子详情 + 赏金
    self.articleDetailTableView = [TLTableView  groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight) delegate:self dataSource:self];
    self.articleDetailTableView.scrollEnabled = NO;
//    [self.bgScrollView addSubview:self.articleDetailTableView];
    
    //7.评论点赞 展示 切换
    self.userActionSwitchView.frame = CGRectMake(0, self.articleDetailTableView.yy, SCREEN_WIDTH, USER_ACTION_SWITCH_HEIGHT);
//    [self.bgScrollView addSubview:self.userActionSwitchView];
    
    
    //假header
    UIView *falseHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight + USER_ACTION_SWITCH_HEIGHT)];
    
    
    //5.点赞的table
    self.dzTableView = [TLTableView  tableViewWithframe:CGRectMake(0, 0, self.bgScrollView.width, self.bgScrollView.height) delegate:self dataSource:self];
    [self.bgScrollView addSubview:self.dzTableView];
    self.dzTableView.backgroundColor = [UIColor backgroundColor];
    self.dzTableView.tableHeaderView = falseHeaderView;
    self.dzHeaderView = falseHeaderView;
    
    //-//
    UIView *falseHeaderView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight + USER_ACTION_SWITCH_HEIGHT)];
    falseHeaderView1.backgroundColor = [UIColor backgroundColor];
    [falseHeaderView1 addSubview:self.articleDetailTableView];
    [falseHeaderView1 addSubview:self.userActionSwitchView];
    self.commentHeaderView = falseHeaderView1;
    
    //4.评论的tableView
    self.commentTableView = [TLTableView  tableViewWithframe:self.dzTableView.frame delegate:self dataSource:self];
    self.commentTableView.backgroundColor = [UIColor cyanColor];
    self.commentTableView.tableHeaderView = falseHeaderView1;
    self.commentTableView.backgroundColor = [UIColor backgroundColor];
    [self.bgScrollView addSubview:self.commentTableView];
    
    
    //调整 背景scrollView暂无-----特殊用途，可能view也可以
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.bgScrollView.height);
    
    //
    //调整contentSize
    self.commentTableView.contentSize = CGSizeMake
    (SCREEN_WIDTH, self.bgScrollView.height + self.articleDetailTableViewHeigth);
    
    //
    self.dzTableView.contentSize = self.commentTableView.contentSize;
    
    
}

- (CSWUserActionSwitchView *)userActionSwitchView {

    if (!_userActionSwitchView) {
        
        _userActionSwitchView = [[CSWUserActionSwitchView alloc] init];
        _userActionSwitchView.delegate = self;
    }
    
    return _userActionSwitchView;

}

#pragma mark- 点赞和评论的切换
- (void)didSwitch:(NSInteger)idx {
    
    self.isComment = idx == 0;

//    [self.articleDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (idx == 0) {
        //评论
        self.commentTableView.hidden = NO;
        self.dzTableView.hidden = YES;
        [self.commentHeaderView  addSubview:self.articleDetailTableView];
        [self.commentHeaderView  addSubview:self.userActionSwitchView];

    } else {
        
        self.commentTableView.hidden = YES;
        self.dzTableView.hidden = NO;
//        [self.bgScrollView bringSubviewToFront:self.dzTableView];
        [self.dzHeaderView  addSubview:self.articleDetailTableView];
        [self.dzHeaderView  addSubview:self.userActionSwitchView];

    }

}

#pragma mark- 关注行为
-(void)focusAction:(UIButton *)btn {

    if (![TLUser user].userId) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    if ([self.layoutItem.article.isDZ isEqual:@1]) {
        //取消关注
        TLNetworking *unFocusHttp = [TLNetworking new];
        unFocusHttp.showView = self.view;
        unFocusHttp.code = @"805081";
        unFocusHttp.parameters[@"userId"] = [TLUser user].userId;
        unFocusHttp.parameters[@"token"] = [TLUser user].token;
        unFocusHttp.parameters[@"toUser"] = self.layoutItem.article.publisher;
        //
        [unFocusHttp postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithInfo:@"成功取消关注"];
            
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
        focusHttp.parameters[@"toUser"] = self.layoutItem.article.publisher;;
        //
        [focusHttp postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithInfo:@"关注成功"];

        } failure:^(NSError *error) {
            
        }];
    
    }
 

    
    
    

}



#pragma tableView -- dataSource
//--//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.articleDetailTableView]) {
        
        if (indexPath.section == 0) {
            
            return self.layoutItem.cellHeight;
            
        } else {
            
            return SJ_CELL_HEIGHT;
            
        }
        
    } else if ([tableView isEqual:self.commentTableView]) {
    
        return self.commentLayoutItems[indexPath.row].cellHeight;

    } else {
    //点赞
        return 75;

    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([tableView isEqual:self.articleDetailTableView]) {
        
        return 1;
        
    } else if ([tableView isEqual:self.commentTableView]) {
        
        return self.commentLayoutItems.count;
        
    } else {
        //点赞
        return self.dzModels.count;
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    if ([tableView isEqual:self.articleDetailTableView]) {
        
        if (indexPath.section == 0) {
            
            CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
            if (!cell) {
                
                cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            //cell.layoutItem = self.layoutItem;
            cell.layoutItem = self.layoutItem;
            [cell.focusBtn addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        } else {
            
            CSWDaShangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWDaShangCellId"];
            if (!cell) {
                
                cell = [[CSWDaShangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWDaShangCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.recordRoom = self.dsRecordRoom;
            return cell;
            
        }
        
    } else if ([tableView isEqual:self.commentTableView]) {
        //评论的tableView
        
//        if (tableView.contentSize.height < (self.bgScrollView.height + self.articleDetailTableViewHeigth)) {
//            
//            tableView.contentSize = CGSizeMake
//            (SCREEN_WIDTH, self.bgScrollView.height + self.articleDetailTableViewHeigth);
//            
//        }
        
        
        CSWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWCommentCellId"];
        if (!cell) {
            
            cell = [[CSWCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWCommentCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       
        cell.commentLayoutItem = self.commentLayoutItems[indexPath.row];

        return cell;
        
    } else {
        //点赞的tableView
        
        
//        if (tableView.contentSize.height < (self.bgScrollView.height + self.articleDetailTableViewHeigth)) {
//            
//            
//            tableView.contentSize = CGSizeMake
//            (SCREEN_WIDTH, self.bgScrollView.height + self.articleDetailTableViewHeigth);
//            
//        }
        
        //点赞
        CSWDZCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWDZCellID"];
        if (!cell) {
            
            cell = [[CSWDZCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWDZCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //--//
        
        cell.dzModel = self.dzModels[indexPath.row];
        
        return cell;
        
    }
 
    
}


//const
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    if (section == 2) {
//        
//        return self.userActionSwitchView;
//    }
//    
//    return nil;
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    if ([tableView isEqual:self.articleDetailTableView]) {
        
        return 2;
        
    } else if ([tableView isEqual:self.commentTableView]) {
        
        return 1;
        
    } else {
        //点赞
        return 1;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.articleDetailTableView]) {
        return 10;
    }
    return 0.01;
 
}

@end
