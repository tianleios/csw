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
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CSWUserActionSwitchView


- (void)typeSwitch:(UIButton *)btn {

    if ([btn isEqual:self.lastSelectd]) {
        
        return;
    }
    
    self.lastSelectd.selected = NO;
    self.lastSelectd.titleLabel.font = FONT(15);
    
    btn.selected = YES;
    btn.titleLabel.font = FONT(15);
    self.lastSelectd = btn;
    
//    [self.swithcLine layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.swithcLine.centerX = btn.centerX;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(didSwitch:)]) {
            [self.delegate didSwitch:[btn isEqual:self.leftBtn1] ? 0 : 1];
        }
        
    });


    
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
        
        self.isFirst = YES;
        //
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        
        CGFloat margin = 15;

        self.leftBtn1 = [self getBtn];
        self.leftBtn1.titleLabel.font = FONT(15);
        [self addSubview:self.leftBtn1];
        [self.leftBtn1 addTarget:self action:@selector(typeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn2 = [self getBtn];
        [self addSubview:self.leftBtn2];
        [self.leftBtn2 addTarget:self action:@selector(typeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //--//

        
        [self.leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(margin);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
        }];
        
        [self.leftBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn1.mas_top);
            make.left.equalTo(self.leftBtn1.mas_right).offset(margin + 5);
            make.bottom.equalTo(self.leftBtn1.mas_bottom);
        }];
        
        //
    
        
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

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (self.isFirst) {
       
        self.swithcLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 3)];
        [self addSubview:self.swithcLine];
        self.swithcLine.backgroundColor = [UIColor themeColor];
        self.swithcLine.layer.cornerRadius = 1.5;
        self.swithcLine.layer.masksToBounds = YES;
        
        self.isFirst = NO;
        self.swithcLine.y = self.height - 7;
        self.swithcLine.centerX = self.leftBtn1.centerX;
        
    }
  

    
    
//    [self.swithcLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(3);
//        make.width.mas_equalTo(20);
//        make.centerX.equalTo(self.leftBtn1.mas_centerX);
//        make.bottom.equalTo(self.mas_bottom).offset(-3);
//    }];
    
}
@end
