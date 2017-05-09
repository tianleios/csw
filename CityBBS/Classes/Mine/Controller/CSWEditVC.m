//
//  CSWEditVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWEditVC.h"

@interface CSWEditVC ()

@property (nonatomic, strong) TLTextField *contentTf;
@end

@implementation CSWEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hasDone)];
    
    if (!self.editModel) {
        NSLog(@"数据模型？？？？");
        return;
    }
    
    if (self.type == CSWUserEditTypeEmail) {
        
        self.contentTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"邮箱" titleWidth:80 placeholder:@"请输入您的邮箱"];
        self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
        [self.view addSubview:self.contentTf];
        
    } else {
    
        self.contentTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"昵称" titleWidth:80 placeholder:@"请填写昵称"];
        [self.view addSubview:self.contentTf];
    }

    [self.contentTf becomeFirstResponder];
    
}

- (void)hasDone {

    if (self.type == CSWUserEditTypeEmail) {

        
        if ([self.contentTf.text valid]) {
            
            self.editModel.content = self.contentTf.text;

        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.done) {
            self.done();
        }
        
    } else {
        
        if (![self.contentTf.text valid]) {
            [TLAlert alertWithInfo:@"请输入昵称"];
            return;
        }
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805075";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        http.parameters[@"nickname"] = self.contentTf.text;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithInfo:@"修改成功"];
            [TLUser user].nickname = self.contentTf.text;
        
            [[TLUser user] updateUserInfo];
            self.editModel.content = self.contentTf.text;

            if (self.done) {
                self.done();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }


}



@end
