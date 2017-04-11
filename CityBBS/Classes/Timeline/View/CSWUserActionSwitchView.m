//
//  CSWUserActionSwitchView.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserActionSwitchView.h"

@interface CSWUserActionSwitchView()

@property (nonatomic, strong) UILabel *leftLbl1;
@property (nonatomic, strong) UILabel *leftLbl2;
@property (nonatomic, strong) UIView  *swithcLine;

@property (nonatomic, strong) id lastSelectd;

@end

@implementation CSWUserActionSwitchView

- (void)left1Action {
    
    self.swithcLine.translatesAutoresizingMaskIntoConstraints = YES;

    if ([self.lastSelectd isEqual:self.leftLbl1]) {
        return;
    }
    
    self.leftLbl1.textColor = [UIColor textColor];
    self.leftLbl2.textColor = [UIColor textColor2];
    self.lastSelectd = self.leftLbl1;
    
    self.swithcLine.centerX = self.leftLbl1.centerX;
//    [UIView animateWithDuration:0.25 animations:^{
//        
//      
//    }];
//    [self.swithcLine mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.leftLbl1.mas_centerX);
//    }];
   
//    [self.swithcLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(3);
//        make.width.mas_equalTo(20);
//        make.centerX.equalTo(self.leftLbl1.mas_centerX);
//        make.bottom.equalTo(self.mas_bottom).offset(-3);
//    }];
    
}


- (void)left2Action {


    if ([self.lastSelectd isEqual:self.leftLbl2]) {
        return;
    }
    
    self.leftLbl2.textColor = [UIColor textColor];
    self.leftLbl1.textColor = [UIColor textColor2];
    self.lastSelectd = self.leftLbl2;
    
    self.swithcLine.centerX = self.leftLbl1.centerX;

//    [self.swithcLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(3);
//        make.width.mas_equalTo(20);
//        make.centerX.equalTo(self.leftLbl2.mas_centerX);
//        make.bottom.equalTo(self.mas_bottom).offset(-3);
//    }];
    
    [self.swithcLine mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(40);
        
    }];


}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = 15;
        self.leftLbl1 = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor textColor]];
        [self addSubview:self.leftLbl1];
        self.leftLbl1.userInteractionEnabled = YES;
        UITapGestureRecognizer *left1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left1Action)];
        [self.leftLbl1 addGestureRecognizer:left1Tap];
        
        
        self.leftLbl2 = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor textColor2]];
        [self addSubview:self.leftLbl2];
        self.leftLbl2.userInteractionEnabled = YES;
        UITapGestureRecognizer *left2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left2Action)];
        [self.leftLbl2 addGestureRecognizer:left2Tap];
        
        self.swithcLine = [[UIView alloc] init];
        [self addSubview:self.swithcLine];
        self.swithcLine.backgroundColor = [UIColor themeColor];
        self.swithcLine.layer.cornerRadius = 1.5;
        self.swithcLine.layer.masksToBounds = YES;
        
        [self.leftLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(margin);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
        }];
        
        [self.leftLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftLbl1.mas_top);
            make.left.equalTo(self.leftLbl1.mas_right).offset(margin);
            make.bottom.equalTo(self.leftLbl1.mas_bottom);
        }];
        
        [self.swithcLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(20);
            make.centerX.equalTo(self.leftLbl1.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        
        self.lastSelectd = self.leftLbl1;
        self.leftLbl1.text = @"评论500";
        self.leftLbl2.text = @"点赞100";
        
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

@end
