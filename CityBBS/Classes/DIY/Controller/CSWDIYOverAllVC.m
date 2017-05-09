//
//  CSWDIYOverAllVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYOverAllVC.h"
#import <WebKit/WebKit.h>

@interface CSWDIYOverAllVC ()<WKNavigationDelegate>


@end

@implementation CSWDIYOverAllVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:req];
    
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [TLProgressHUD showWithStatus:@"加载中...."];
}

//--//
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
}

@end
