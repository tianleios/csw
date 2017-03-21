//
//  TLTabBar.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTabBar.h"
#import "UIButton+WebCache.h"
#import "TLBarButton.h"

@interface TLTabBar()

@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIView *falseTabBar;
@property (nonatomic, strong) NSMutableArray <TLBarButton *>*btns;


@end

@implementation TLTabBar
{

    TLBarButton *_lastTabBarBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)falseTabBar {

    if (!_falseTabBar) {
        
        _falseTabBar = [[UIView alloc] initWithFrame:self.bounds];
        _falseTabBar.userInteractionEnabled = YES;
        _falseTabBar.backgroundColor = [UIColor whiteColor];
        _falseTabBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //添加4个按钮
        
        CGFloat w  = self.width/5.0;
        self.btns = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i = 0; i < 5; i ++) {
            
            if (i == 2) {
                
                
                continue;
            }
            TLBarButton *btn = [[TLBarButton alloc] initWithFrame:CGRectMake(i*w, 0, w, _falseTabBar.height)];
            [_falseTabBar addSubview:btn];
            btn.iconImageView.image = [UIImage imageNamed:@"有料_un"];
//            btn.titleLbl.text = @"有料";
            btn.titleLbl.textColor = [UIColor colorWithHexString:@"#484848"];
            [btn addTarget:self action:@selector(hasChoose:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i > 1 ? 100 + i - 1 : 100 + i;
            [self.btns addObject:btn];
            
            if (i == 0) {
                _lastTabBarBtn = btn;
                _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:@"有料"];
                _lastTabBarBtn.selected = YES;
                _lastTabBarBtn.titleLbl.textColor = [UIColor themeColor];
                
            }
        }
        
        //中间小蜜
        UIImageView * imageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小蜜"]];
        imageView.userInteractionEnabled = YES;
        [_falseTabBar addSubview:imageView];
        self.middleImageView = imageView;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_falseTabBar.mas_centerX);
            make.bottom.equalTo(_falseTabBar.mas_bottom).offset(-5);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedXiaoMi)];
        [imageView addGestureRecognizer:tap];
        
    }
    
    return _falseTabBar;
}

- (void)setTabNames:(NSArray *)tabNames {

    _tabNames = tabNames;
    
    [self.btns enumerateObjectsUsingBlock:^(TLBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.titleLbl.text = _tabNames[idx];
        
    }];
    

}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self addSubview:self.falseTabBar];

}

- (void)hint {


}

- (void)selectedXiaoMi {

    if (self.tl_delegate && [self.tl_delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        [self.tl_delegate didSelectedMiddleItemTabBar:self];
    }

}

- (void)hasChoose:(TLBarButton *)btn {

    if ([_lastTabBarBtn isEqual:btn]) {
        
        return;
    }
    
    NSInteger idx = btn.tag - 100;
    _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:@"有料_un"];
    _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
    
    btn.iconImageView.image = [UIImage imageNamed:@"有料"];
    btn.titleLbl.textColor = [UIColor themeColor];
    
    btn.selected = NO;
    _lastTabBarBtn = btn;
    _lastTabBarBtn.selected = YES;

    if (self.tl_delegate && [self.tl_delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        [self.tl_delegate didSelected:idx tabBar:self];
    }
    

}

//fix: 超出父视图，无法显示
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {


    UIView *v = [super hitTest:point withEvent:event];
    
    if (v == nil) {
        
        CGPoint falsePoint = [self.middleImageView convertPoint:point fromView:self.falseTabBar];
        if ([self.middleImageView.layer containsPoint:falsePoint]) {
            return self.middleImageView;
        } else {
        
            return nil;
        }
        
    }
    
    return v;
}


@end


