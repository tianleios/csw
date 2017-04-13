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
#import "CSWCommentInputView.h"
#import "CSWCommentCell.h"
#import "CSWCommentLayoutItem.h"
#import "CSWDZCell.h"

#define USER_ACTION_SWITCH_HEIGHT 40
#define SJ_CELL_HEIGHT 80
#define COMMENT_INPUT_VIEW_HEIGHT 49


@interface CSWArticleDetailVC ()<UITableViewDelegate,UITableViewDataSource,CSWUserActionSwitchDelegate>

@property (nonatomic, strong) CSWCommentInputView *commentInputView;

@property (nonatomic, strong) NSMutableArray <CSWCommentLayoutItem *> *commentLayoutItems;
@property (nonatomic, strong) NSMutableArray <CSWLikeModel *>*dzModels;

@property (nonatomic, assign) BOOL isComment;

//重新设计
@property (nonatomic, strong) UIScrollView  *bgScrollView; //背景
@property (nonatomic, strong) CSWUserActionSwitchView *userActionSwitchView; //切换卡

@property (nonatomic, strong) TLTableView *articleDetailTableView; //显示帖子详情 + 赏金


@property (nonatomic, strong) TLTableView *commentTableView; //评论
@property (nonatomic, strong) TLTableView *dzTableView; //点赞

@property (nonatomic, assign) CGFloat articleDetailTableViewHeigth;
@property (nonatomic, strong) UIView *commentHeaderView;
@property (nonatomic, strong) UIView *dzHeaderView;

@end

@implementation CSWArticleDetailVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    //UI
    [self setUpUI];
    
    //评论点赞数据
    self.userActionSwitchView.countStrRoom = @[[self.layoutItem.article.sumComment stringValue],[self.layoutItem.article.sumLike stringValue]];
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    //获取评论
    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
    http.code = @"610133";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
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
            [self.commentTableView reloadData];
            
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
        
        [self.dzTableView reloadData];

    } failure:^(NSError *error) {
        
    }];

    



}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ([self.bgScrollView isEqual:scrollView]) {
        return;
    }

  
   
    if ([scrollView isEqual:self.commentTableView]) {
        
        self.dzTableView.contentOffset = scrollView.contentOffset;
        if(scrollView.contentOffset.y > 0 ) {
        
            //1.
            if (scrollView.contentOffset.y > self.articleDetailTableViewHeigth) {
            
                 self.userActionSwitchView.y = scrollView.contentOffset.y;
            } else {
            
                self.userActionSwitchView.y = self.articleDetailTableViewHeigth;

            }
            
            
            
            //2.
//            self.articleDetailTableView.y = -scrollView.contentOffset.y;
//            self.userActionSwitchView.y = self.articleDetailTableViewHeigth -scrollView.contentOffset.y;
//            if (scrollView.contentOffset.y > self.articleDetailTableViewHeigth) {
//                
//                self.userActionSwitchView.y = 0;
//            }
            
        }
        
    } else {
    
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


    CGFloat articleDetailTableViewHeight = _layoutItem.cellHeight + SJ_CELL_HEIGHT;
    self.articleDetailTableViewHeigth = articleDetailTableViewHeight;
    
    
    //1.背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - COMMENT_INPUT_VIEW_HEIGHT)];
    self.bgScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.delegate = self;
    
    self.commentInputView = [[CSWCommentInputView alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, SCREEN_WIDTH, COMMENT_INPUT_VIEW_HEIGHT)];
    self.commentInputView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.commentInputView];

    

    
    
    //假header
    UIView *falseHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight + USER_ACTION_SWITCH_HEIGHT)];
    
 
    
    
    
    //6.帖子详情 + 赏金
    self.articleDetailTableView = [TLTableView  groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight) delegate:self dataSource:self];
    self.articleDetailTableView.scrollEnabled = NO;
    [self.bgScrollView addSubview:self.articleDetailTableView];
    
    //7.评论点赞切换
    self.userActionSwitchView.frame = CGRectMake(0, self.articleDetailTableView.yy, SCREEN_WIDTH, USER_ACTION_SWITCH_HEIGHT);
    [self.bgScrollView addSubview:self.userActionSwitchView];
    
 
    
    //
    //5.点赞的table
    self.dzTableView = [TLTableView  tableViewWithframe:CGRectMake(0, 0, self.bgScrollView.width, self.bgScrollView.height) delegate:self dataSource:self];
    [self.bgScrollView addSubview:self.dzTableView];
    self.dzTableView.backgroundColor = [UIColor backgroundColor];
    self.dzTableView.tableHeaderView = falseHeaderView;
    self.dzHeaderView = falseHeaderView;
    
    
    UIView *falseHeaderView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, articleDetailTableViewHeight + USER_ACTION_SWITCH_HEIGHT)];
    falseHeaderView1.backgroundColor = [UIColor redColor];
    [falseHeaderView1 addSubview:self.articleDetailTableView];
    [falseHeaderView1 addSubview:self.userActionSwitchView];
    self.commentHeaderView = falseHeaderView1;
    
    //4.评论的table
    self.commentTableView = [TLTableView  tableViewWithframe:self.dzTableView.frame delegate:self dataSource:self];
    self.commentTableView.backgroundColor = [UIColor cyanColor];
    self.commentTableView.tableHeaderView = falseHeaderView1;
    self.commentTableView.backgroundColor = [UIColor backgroundColor];
    [self.bgScrollView addSubview:self.commentTableView];
    
    

    
   
 
    
    
    //调整
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.bgScrollView.height);
//
//    self.bgScrollView.height + articleDetailTableViewHeight
//    self.dzTableView.height = self.bgScrollView.contentSize.height;
//    self.commentTableView.height = self.bgScrollView.contentSize.height;
    
//    self.commentTableView.scrollEnabled = NO;
//    self.dzTableView.scrollEnabled = NO;

}



#pragma mark- 键盘通知监测
- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    [UIView animateWithDuration:duration animations:^{
        
        self.commentInputView.y = CGRectGetMinY(keyBoardFrame) - 49 - 64;

    }];
    
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
        [self.commentTableView addSubview:self.articleDetailTableView];
        [self.commentTableView addSubview:self.userActionSwitchView];

        
    } else {
        
        self.commentTableView.hidden = YES;
        self.dzTableView.hidden = NO;
//        [self.bgScrollView bringSubviewToFront:self.dzTableView];
        [self.dzHeaderView addSubview:self.articleDetailTableView];
        [self.dzHeaderView addSubview:self.userActionSwitchView];

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
    
    
    
    if ([tableView isEqual:self.articleDetailTableView]) {
        
        if (indexPath.section == 0) {
            
            CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
            if (!cell) {
                
                cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            
            //cell.layoutItem = self.layoutItem;
            cell.layoutItem = self.layoutItem;
            return cell;
            
        } else {
            
            CSWDaShangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWDaShangCellId"];
            if (!cell) {
                
                cell = [[CSWDaShangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWDaShangCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }
            
            return cell;
            
        }
        
    } else if ([tableView isEqual:self.commentTableView]) {
        
        if (tableView.contentSize.height < (self.bgScrollView.height + self.articleDetailTableViewHeigth)) {
            
            
            tableView.contentSize = CGSizeMake
            (SCREEN_WIDTH, self.bgScrollView.height + self.articleDetailTableViewHeigth);
            
        }
        
        CSWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWCommentCellId"];
        if (!cell) {
            
            cell = [[CSWCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWCommentCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.commentLayoutItem = self.commentLayoutItems[indexPath.row];
        }
        
       
        
        return cell;
    } else {
        
        if (tableView.contentSize.height < (self.bgScrollView.height + self.articleDetailTableViewHeigth)) {
            
            
            tableView.contentSize = CGSizeMake
            (SCREEN_WIDTH, self.bgScrollView.height + self.articleDetailTableViewHeigth);
            
        }
        //点赞
        CSWDZCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWDZCellID"];
        if (!cell) {
            
            cell = [[CSWDZCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWDZCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dzModel = self.dzModels[indexPath.row];
        }
        
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
    
    return 0.01;
}

@end
