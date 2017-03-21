//
//  CSWSwitchView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSwitchView.h"

@interface CSWSwitchView()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *line;

@end


@implementation CSWSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w = frame.size.width/2.0;
        CGFloat h = frame.size.height;
        
        self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [self.leftBtn setTitle:@"有料" forState:UIControlStateNormal];
        [self addSubview:self.leftBtn];
        self.leftBtn.titleLabel.font = FONT(17);
        [self.leftBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.tag = 100;
        
        //
        self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, w, h)];
        [self.rightBtn setTitle:@"论坛" forState:UIControlStateNormal];
        [self addSubview:self.rightBtn];
        [self.rightBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.titleLabel.font = self.leftBtn.titleLabel.font;
        self.rightBtn.tag = 101;

        
       //
        CGFloat bh = 4;
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, h - bh, w, bh)];
        [self addSubview:self.line];
        self.line.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    _selectedIndex = selectedIndex;
    
    if (selectedIndex >= self.subviews.count) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.line.x = _selectedIndex * self.width/2.0;

    }];

}

//---//
- (void)change:(UIButton *)btn {


    [UIView animateWithDuration:0.25 animations:^{
        self.line.centerX  = btn.centerX;
    }];
    
    if (self.selected) {
        self.selected(btn.tag - 100);
    }
}

@end
