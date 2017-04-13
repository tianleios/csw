//
//  CSWReportVCViewController.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWReportVC.h"
#import "CSWArticleApi.h"

@interface CSWReportVC ()

@property (nonatomic, strong) UITextView *contentTf;

@end

@implementation CSWReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:0 target:self action:@selector(report)];
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(10, 5, 200, 40) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(15) textColor:[UIColor textColor]];
    [self.view addSubview:lbl];
    lbl.text = @"请在下方输入举报理由";
    
    UITextView *contetnTf = [[UITextView alloc] initWithFrame:CGRectMake(0, lbl.yy, SCREEN_WIDTH, 120)];
    contetnTf.font = FONT(15);
    self.contentTf = contetnTf;
    contetnTf.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contetnTf];
    
}


- (void)report {
    
    if (![self.contentTf.text valid]) {
        [TLAlert alertWithInfo:@"请填写举报理由"];
        return;
    }

    if (self.isReportComment) {
        
        [CSWArticleApi reportCommentWithCommentCode:self.reportObjCode
                                           reporter:[TLUser user].userId
                                         reportNote:self.contentTf.text
                                            success:^{
                                                [TLAlert alertWithInfo:@"举报成功"];
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                            failure:^{
                                                
                                            }];
        return;
    }
    [CSWArticleApi reportArticleWithArticleCode:self.reportObjCode
                                       reporter:[TLUser user].userId
                                     reportNote:self.contentTf.text
                                        success:^{
                                            [TLAlert alertWithInfo:@"举报成功"];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
                                        failure:^{
                                            
                                        }];
    

}

@end
