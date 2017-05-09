//
//  CSWWebVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/5/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWWebVC.h"
#import <WebKit/WebKit.h>

@interface CSWWebVC ()<WKNavigationDelegate>

@end

@implementation CSWWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webVC = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webVC];
    webVC.navigationDelegate = self;
    
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webVC loadRequest:req];
    
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [TLProgressHUD showWithStatus:@"加载中...."];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [TLProgressHUD dismiss];

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
