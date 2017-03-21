//
//  CSWArticleTypeSwitchView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleTypeSwitchView.h"

@interface CSWArticleTypeSwitchView()

@property (nonatomic, strong) UIView *switchLine;
@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation CSWArticleTypeSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    
        //上线
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor lineColor];
        [self addSubview:topLine];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.mas_top);
        }];
        
        //底线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //切换线
        self.switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, 100, 1)];
        self.switchLine.backgroundColor = [UIColor themeColor];
        [self addSubview:self.switchLine];
        
        self.itemWidth = 100;
        self.intervalMargin = 50;
    }
    return self;
}

- (void)setTypeNames:(NSArray *)typeNames {

    _typeNames = typeNames;
    
    self.switchLine.width = self.itemWidth;
    
    CGFloat count = _typeNames.count;
    CGFloat leftM = (self.width - count * _itemWidth - (count - 1)*_intervalMargin)/2.0;
   
    [_typeNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat x = leftM + (_itemWidth + _intervalMargin)*idx;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, _itemWidth, self.height)];
        [btn setTitle:obj forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + idx;
        btn.titleLabel.font = FONT(15);
        [self addSubview:btn];
        
        if (idx == 0) {
            
            self.lastBtn = btn;
            self.switchLine.width = self.itemWidth;
            self.switchLine.centerX = self.lastBtn.centerX;
            self.lastBtn.selected = YES;

        }
        
    }];

}


- (void)setSelectedIdx:(NSInteger)selectedIdx {

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[UIButton class]]) {
            
            if (obj.tag == selectedIdx + 100) {
                
                UIButton *btn = (UIButton *)obj;
                if (![btn isEqual:self.lastBtn]) {
                    self.lastBtn.selected = NO;
                    btn.selected = YES;
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.switchLine.centerX = btn.centerX;
                    }];
                    self.lastBtn = btn;

                }
            }
            
        }
    }];

}

//
- (void)tapBtn:(UIButton *)btn {

    NSInteger idx = btn.tag - 100;

    if (![btn isEqual:self.lastBtn]) {
        //调用选中
        self.lastBtn.selected = NO;
        btn.selected = YES;
        self.lastBtn = btn;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        
    }];
    
    if (self.selected) {
        self.selected(idx);
    }
    
}

@end
