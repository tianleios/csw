//
//  TLUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserLoginVC.h"
#import "TLUserRegistVC.h"
#import "TLUserForgetPwdVC.h"
#import "TLNavigationController.h"
//#import "ZHHomeVC.h"
#import "ChatManager.h"

@interface TLUserLoginVC ()

@property (nonatomic,strong) TLAccountTf *phoneTf;
@property (nonatomic,strong) TLAccountTf *pwdTf;

@end

@implementation TLUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    [self setUpUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];

}

- (void)back {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

//登录成功
- (void)login {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginSuccess) {
        self.loginSuccess();
    }

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    
}

- (void)findPwd {

    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)goReg {

    [self.navigationController pushViewController:[[TLUserRegistVC alloc] init] animated:YES];

}

- (void)goLogin {
    
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }

    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;

    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    [http postWithSuccess:^(id responseObject) {
        
       NSString *token = responseObject[@"data"][@"token"];
       NSString *userId = responseObject[@"data"][@"userId"];

       //1.获取用户信息
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = USER_INFO;
        http.parameters[@"userId"] = userId;
        http.parameters[@"token"] = token;
        [http postWithSuccess:^(id responseObject) {
          
            NSDictionary *userInfo = responseObject[@"data"];
                
                //登录环信
                if ([[ChatManager defaultManager] loginWithUserName:userId]) {
                    
                    //保存用户信息
                    [TLUser user].userId = userId;
                    [TLUser user].token = token;
                    
                    //保存用户信息
                    [[TLUser user] saveUserInfo:userInfo];
                    
                    //初始化用户信息
                    [[TLUser user] setUserInfoWithDict:userInfo];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
                    
                } else {
                    
                    [TLAlert alertWithInfo:@"登录失败"];
                    
                }
                

            } failure:^(NSError *error) {
                
                
            }];
            
        } failure:^(NSError *error) {
            
            
        }];

 
    
}

#pragma mark- 微信登录
- (void)wxLogin {


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
    
}


- (void)setUpUI {
    
    
    UIScrollView *bgSV = self.bgSV;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    //账号
    TLAccountTf *phoneTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(margin, 50, w, h)];
    phoneTf.leftIconView.image = [UIImage imageNamed:@"用户名"];
    phoneTf.tl_placeholder = @"请输入手机号号码或用户名";
    [bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;

    
    //密码
    TLAccountTf *pwdTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + 1, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.tl_placeholder = @"请输入密码";
    [bgSV addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //找回密码
    UIButton *forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,pwdTf.yy + 10 , 100, 25) title:@"找回密码" backgroundColor:[UIColor clearColor]];
    [forgetPwdBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [bgSV addSubview:forgetPwdBtn];
    forgetPwdBtn.titleLabel.font = [UIFont thirdFont];
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetPwdBtn.xx = SCREEN_WIDTH - margin;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    //登陆
    UIButton *loginBtn = [UIButton zhBtnWithFrame:CGRectMake(margin,pwdTf.yy + 55, w, h) title:@"登录"];
    [bgSV addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];

    
    //注册
    UIButton *regBtn = [UIButton borderBtnWithFrame:CGRectMake(margin,loginBtn.yy + 30, w, h) title:@"注册" borderColor:[UIColor themeColor]];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [bgSV addSubview:regBtn];
    [regBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];

    //其它登陆方式
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, regBtn.yy + 30, SCREEN_WIDTH, 10)
textAligment:NSTextAlignmentCenter
backgroundColor:[UIColor clearColor]
font:FONT(12) textColor:[UIColor textColor]];
    [bgSV addSubview:hintLbl];
    hintLbl.text = @"其他登录方式";
    
    //
    UIButton *wxLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, hintLbl.yy + 20, 35, 35)];
    [bgSV addSubview:wxLoginBtn];
    [wxLoginBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    wxLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
     wxLoginBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [wxLoginBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
    
}
@end
