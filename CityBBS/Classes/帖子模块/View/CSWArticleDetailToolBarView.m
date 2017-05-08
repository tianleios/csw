//
//  CSWArticleDetailToolBarView.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleDetailToolBarView.h"

@interface CSWArticleDetailToolBarView()

@property (nonatomic, strong) UIButton *dzBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation CSWArticleDetailToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.top.equalTo(self.mas_top);
        }];
        
        //点赞
        //more
        self.moreBtn = [[UIButton alloc] init];
        [self addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@30);
        }];
        
        [self.moreBtn setImage:[UIImage imageNamed:@"article_more"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        
        //点赞
        self.dzBtn = [[UIButton alloc] init];
        [self addSubview:self.dzBtn];
        [self.dzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moreBtn.mas_left).offset(-15);
            make.width.equalTo(@30);

            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
            
        }];
        [self.dzBtn setImage:[UIImage imageNamed:@"article_dz_normal"] forState:UIControlStateNormal];
        [self.dzBtn addTarget:self action:@selector(dzAction) forControlEvents:UIControlEventTouchUpInside];

        
        
    
        
        //
        UIButton *btn = [[UIButton alloc] init];
            [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.dzBtn.mas_left).offset(-10);
            
            make.top.equalTo(self.mas_top).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];
        [btn setTitle:@"回个话鼓励下楼主" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = FONT(13);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#b4b4b4"].CGColor;
        btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [btn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)moreAction {
    
    //
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *collectionAction = [UIAlertAction actionWithTitle:@"收藏" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.delegate respondsToSelector:@selector(didSelectedAction:action:)]) {
            
            [self.delegate didSelectedAction:self action:CSWArticleDetailToolBarActionTypeCollection];
            
        }
        
    }];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.delegate respondsToSelector:@selector(didSelectedAction:action:)]) {
            
            [self.delegate didSelectedAction:self action:CSWArticleDetailToolBarActionTypeReport];
        }
        
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCtrl addAction:collectionAction];
    [alertCtrl addAction:reportAction];
    [alertCtrl addAction:cancleAction];

    //找出响应者
    UIResponder *nextResponder = [self nextResponder];
    do {
        
      nextResponder  = [nextResponder nextResponder];

    } while (![nextResponder isKindOfClass:[UIViewController class]]);
    
    [(UIViewController *)nextResponder presentViewController:alertCtrl animated:YES completion:nil];
    
}

- (void)dzAction {

    if ([self.delegate respondsToSelector:@selector(didSelectedAction:action:)]) {
        
        [self.delegate didSelectedAction:self action:CSWArticleDetailToolBarActionTypeDZ];
        
    }

}

- (void)send {

    if ([self.delegate respondsToSelector:@selector(didSelectedAction:action:)]) {
        
        [self.delegate didSelectedAction:self action:CSWArticleDetailToolBarActionTypeSendCompose];
    }

}

- (void)dzSuccess {

    [self.dzBtn setImage:[UIImage imageNamed:@"article_dz_hilight"] forState:UIControlStateNormal];

}

- (void)dzFailure {
    
    [self.dzBtn setImage:[UIImage imageNamed:@"article_dz_normal"] forState:UIControlStateNormal];
    
}


@end
