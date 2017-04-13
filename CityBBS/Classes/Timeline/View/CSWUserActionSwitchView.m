//
//  CSWUserActionSwitchView.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserActionSwitchView.h"

@interface CSWUserActionSwitchView()

//@property (nonatomic, strong) UILabel *leftLbl1;
//@property (nonatomic, strong) UILabel *leftLbl2;

@property (nonatomic, strong) UIButton *leftBtn1;
@property (nonatomic, strong) UIButton *leftBtn2;
@property (nonatomic, strong) UIView  *swithcLine;

@property (nonatomic, strong) UIButton * lastSelectd;

@end

@implementation CSWUserActionSwitchView


- (void)typeSwitch:(UIButton *)btn {

    if ([btn isEqual:self.lastSelectd]) {
        
        return;
    }
    
    self.lastSelectd.selected = NO;
    btn.selected = YES;
    self.lastSelectd = btn;
    
    [self.swithcLine layoutIfNeeded];
    [UIView animateWithDuration:2 animations:^{
        
        [self.swithcLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(20);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
            
        }];
        
        [self.swithcLine layoutIfNeeded];
    }];
    

    
    if ([self.delegate respondsToSelector:@selector(didSwitch:)]) {
        [self.delegate didSwitch:[btn isEqual:self.leftBtn1] ? 0 : 1];
    }
    
}

- (UIButton *)getBtn {

    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = FONT(15);
    [btn setTitleColor:[UIColor textColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor textColor2] forState:UIControlStateNormal];

    return btn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = 15;

        self.leftBtn1 = [self getBtn];
        [self addSubview:self.leftBtn1];
        [self.leftBtn1 addTarget:self action:@selector(typeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn2 = [self getBtn];
        [self addSubview:self.leftBtn2];
        [self.leftBtn2 addTarget:self action:@selector(typeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //--//
        self.swithcLine = [[UIView alloc] init];
        [self addSubview:self.swithcLine];
        self.swithcLine.backgroundColor = [UIColor themeColor];
        self.swithcLine.layer.cornerRadius = 1.5;
        self.swithcLine.layer.masksToBounds = YES;
        
        [self.leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(margin);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
        }];
        
        [self.leftBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn1.mas_top);
            make.left.equalTo(self.leftBtn1.mas_right).offset(margin);
            make.bottom.equalTo(self.leftBtn1.mas_bottom);
        }];
        
        //
        [self.swithcLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(20);
            make.centerX.equalTo(self.leftBtn1.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        UIView *topline = [[UIView alloc] init];
        topline.backgroundColor = [UIColor lineColor];
        [self addSubview:topline];
        [topline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.top.equalTo(self.mas_top);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.lastSelectd = self.leftBtn1;
        self.lastSelectd.selected = YES;
        
 
 
        
    }
    return self;
}
- (void)setCountStrRoom:(NSArray<NSString *> *)countStrRoom{

    _countStrRoom = [countStrRoom copy];
    if (_countStrRoom.count < 2) {
        return;
    }
    
    [self.leftBtn1 setTitle:[NSString stringWithFormat:@"评论%@",_countStrRoom[0]] forState:UIControlStateNormal];
    [self.leftBtn2 setTitle:[NSString stringWithFormat:@"点赞%@",_countStrRoom[1]] forState:UIControlStateNormal];
}
@end
