//
//  CSWDIYOverAllVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYOverAllVC.h"
#import <WebKit/WebKit.h>

@interface CSWDIYOverAllVC ()

@end

@implementation CSWDIYOverAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://segmentfault.com"]];
    [webView loadRequest:req];
    
}

@end
