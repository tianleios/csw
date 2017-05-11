//
//  CSWMineHeaderVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWMineHeaderView.h"

@interface CSWMineHeaderView()

@property (nonatomic, strong) NSMutableArray <UILabel *>*lbls;

@end

@implementation CSWMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 80)];
        self.userPhoto.layer.cornerRadius = 40;
        self.userPhoto.layer.masksToBounds = YES;
        [self addSubview:self.userPhoto];
   
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.userPhoto.mas_centerY);
            make.left.equalTo(self.userPhoto.mas_right).offset(17);
            
        }];
        
        //
        self.levelLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(11)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self addSubview:self.levelLbl];
        [self.levelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.nameLbl.mas_bottom).offset(5);
            make.left.equalTo(self.nameLbl);
            
        }];
        
        //箭头
        UIImageView *arrowImageView= [[UIImageView alloc] init];
        [self addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"mine_more"];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(12);
            make.centerY.equalTo(self.userPhoto.mas_centerY).offset(10);
            
        }];
        
        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, self.userPhoto.yy + 20, SCREEN_WIDTH - 20, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
   
        
        //四部分 帖子关注 粉丝 赏金
        CGFloat y = line.yy;
        CGFloat w = (self.width - 20)/4.0;
        CGFloat h = 60;
        NSArray *typeNames = @[@"帖子",@"关注",@"粉丝",@"赏金"];
        
        self.lbls = [[NSMutableArray alloc] init];
        __block UIButton *lastBtn;
        [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = 10 + idx*w;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:btn];
            [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
//            btn.backgroundColor = RANDOM_COLOR;
            [btn addTarget:self action:@selector(goFlowDetal:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = idx + 100;
            
            lastBtn = btn;
            
            //
            UILabel *numLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentCenter
                                      backgroundColor:[UIColor clearColor] font:FONT(14)
                                            textColor:[UIColor textColor]];
            [btn addSubview:numLbl];
            [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_left);
                make.right.equalTo(btn.mas_right);
                make.top.equalTo(btn.mas_top).offset(10);
            }];
            [self.lbls addObject:numLbl];
            numLbl.text = @"--";
            
            //
            UILabel *typeNameLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentCenter
                                      backgroundColor:[UIColor clearColor] font:FONT(12)
                                            textColor:[UIColor colorWithHexString:@"#666666"]];
            [btn addSubview:typeNameLbl];
            typeNameLbl.text = typeNames[idx];
            [typeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_left);
                make.right.equalTo(btn.mas_right);
                make.top.equalTo(numLbl.mas_bottom).offset(8);
            }];
            
        }];
        
        self.height = lastBtn.yy;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeDefault idx:0];
    }

}

- (void)goFlowDetal:(UIButton *)btn {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeFlow idx:btn.tag - 100];
        
    }

}

- (void)setArticelNum:(NSNumber *)articelNum {

    _articelNum = articelNum;
    
    self.lbls[0].text = [NSString stringWithFormat:@"%@",_articelNum];

}

- (void)setFocusNum:(NSNumber *)focusNum {

    _focusNum = focusNum;
    
    self.lbls[1].text = [NSString stringWithFormat:@"%@",_focusNum];

}


- (void)setFansNum:(NSNumber *)fansNum {

    _fansNum = fansNum;
    self.lbls[2].text = [NSString stringWithFormat:@"%@",_fansNum];

}


- (void)setSjNumText:(NSString *)sjNumText {

    _sjNumText = sjNumText;
    self.lbls[3].text = _sjNumText;


}


- (void)reset {

    [self.lbls enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = @"--";
    }];

}




//
- (void)setNumberArray:(NSArray *)numberArray {

    _numberArray = numberArray;
    [_numberArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        self.lbls[idx].text = [NSString stringWithFormat:@"%@",obj];
        
    }];

}





@end
