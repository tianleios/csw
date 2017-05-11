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


- (void)setTabBarItems:(NSArray<TLTabBarItem *> *)tabBarItems {

    _tabBarItems = [tabBarItems copy];
    
    //
    if (_tabBarItems && (_tabBarItems.count == self.btns.count)) {
        
        [_tabBarItems enumerateObjectsUsingBlock:^(TLTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLBarButton *barBtn = self.btns[idx];
            barBtn.titleLbl.text = obj.title;
            
            //图片
            if (barBtn.isCurrentSelected) {
                
                [barBtn.iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.selectedImgUrl]];
            } else {
                
                [barBtn.iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.unSelectedImgUrl ]];
            
            }
            
            
        }];
        
    }

}



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
//            btn.iconImageView.image = [UIImage imageNamed:@"有料_un"];
//            btn.titleLbl.text = @"有料";
            btn.titleLbl.textColor = [UIColor colorWithHexString:@"#484848"];
            [btn addTarget:self action:@selector(hasChoose:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i > 1 ? 100 + i - 1 : 100 + i;
            [self.btns addObject:btn];
            
            if (i == 0) {
                _lastTabBarBtn = btn;
//                _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:@"有料"];
                _lastTabBarBtn.selected = YES;
                btn.isCurrentSelected = YES;
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



- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self addSubview:self.falseTabBar];

}

- (void)hint {


}

- (void)selectedXiaoMi {

    if (self.tl_delegate && [self.tl_delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        if( [self.tl_delegate didSelectedMiddleItemTabBar:self]) {
        
        }
    }

}

- (void)setSelectedIdx:(NSInteger)selectedIdx {

    _selectedIdx = selectedIdx;
    
    [self.btns enumerateObjectsUsingBlock:^(TLBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == selectedIdx) {
            
            //上一个选中改变
            _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
            _lastTabBarBtn.isCurrentSelected = NO;
            NSString *lastUrlStr = self.tabBarItems[_lastTabBarBtn.tag - 100].unSelectedImgUrl;
            [_lastTabBarBtn.iconImageView sd_setImageWithURL:[NSURL URLWithString:lastUrlStr]];
            
            
            //---//
            //当前选中改变
            obj.titleLbl.textColor = [UIColor themeColor];
            obj.isCurrentSelected = YES;
            NSString *currentUrlStr = self.tabBarItems[idx].selectedImgUrl;
            [obj.iconImageView sd_setImageWithURL:[NSURL URLWithString:currentUrlStr]];
            
            _lastTabBarBtn = obj;

            //
            *stop = YES;
            
        }
    }];
    


}

//点击按钮，
- (void)hasChoose:(TLBarButton *)btn {

    if ([_lastTabBarBtn isEqual:btn]) {
        
        return;
    }
    
    //当前选中的小标
    NSInteger idx = btn.tag - 100;
    
    //--//
    
    if (self.tl_delegate && [self.tl_delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        
        if([self.tl_delegate didSelected:idx tabBar:self]) {
        
            [self changeUIWithCurrentSelectedBtn:btn idx:idx];

        }
        
    } else {

        [self changeUIWithCurrentSelectedBtn:btn idx:idx];
        
    }
    

}

- (void)changeUIWithCurrentSelectedBtn:(TLBarButton *)btn idx:(NSInteger)idx {

    _lastTabBarBtn.isCurrentSelected = NO;
    btn.isCurrentSelected = YES;
    
    NSInteger lastIdx = _lastTabBarBtn.tag - 100;
    //上次选中改变图片
    NSString *unselectedStr = self.tabBarItems[lastIdx].unSelectedImgUrl ;
    
    [_lastTabBarBtn.iconImageView sd_setImageWithURL:[NSURL URLWithString:unselectedStr] placeholderImage:nil];
    
    _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
    
    //当前选中改变图片
    NSString *selectedStr = self.tabBarItems[idx].selectedImgUrl;
    [btn.iconImageView sd_setImageWithURL:[NSURL URLWithString:selectedStr] placeholderImage:nil];
    btn.titleLbl.textColor = [UIColor themeColor];
    
    //--//
    btn.selected = NO;
    _lastTabBarBtn = btn;
    _lastTabBarBtn.selected = YES;
    
}

////fix: 超出父视图，无法显示
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    
//    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
//    if (canNotResponseEvent) {
//        return nil;
//    }
//
//    UIView *v = [super hitTest:point withEvent:event];
//    
//    if (v == nil) {
//        
//        
//        if (!self.middleImageView && ![self pointInside:point withEvent:event]) {
//            return nil;
//        }
//        if (self.middleImageView) {
//            CGRect plusButtonFrame = self.middleImageView.frame;
//            BOOL isInPlusButtonFrame = CGRectContainsPoint(plusButtonFrame, point);
//            if (!isInPlusButtonFrame && (point.y < 0) ) {
//                return nil;
//            }
//            if (isInPlusButtonFrame) {
//                return self.middleImageView;
//            }
//        }
//        
////        CGPoint falsePoint = [self.middleImageView convertPoint:point fromView:self.falseTabBar];
////        if ([self.middleImageView.layer containsPoint:falsePoint]) {
////            return self.middleImageView;
////        } else {
////        
////            return nil;
////        }
//        
//    }
//    
//    return v;
//    
//  
//}


@end


