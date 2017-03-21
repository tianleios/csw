//
//  ZHAccountTf.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLAccountTf.h"

@interface TLAccountTf()




@end
@implementation TLAccountTf

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        

        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, frame.size.height)];
        
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
//        _leftIconView.contentMode = UIViewContentModeCenter;
        _leftIconView.centerY = leftBgView.height/2.0;
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
        //_leftIconView.backgroundColor = [UIColor orangeColor];
        [leftBgView addSubview:_leftIconView];
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14];
//        self.textColor = [[UIColor textColor] colorWithAlphaComponent:0.9];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //白色边界线
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.7, 18)];
//        lineView.backgroundColor = [UIColor textColor];
//        lineView.centerY = frame.size.height/2.0;
//        lineView.centerX = leftBgView.width;
//        
//        [leftBgView addSubview:lineView];
//        self.tintColor = [UIColor themeColor];
//        lineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;

}

- (void)setTl_placeholder:(NSString *)tl_placeholder{

    
    _tl_placeholder = [tl_placeholder copy];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_tl_placeholder attributes:@{
                                                                                                          NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbbbbb"]
                                                                                                          }];
    self.attributedPlaceholder = attrStr;

}

//- (void)setZh_placeholder:(NSString *)zh_placeholder {
//
//    _zh_placeholder = [zh_placeholder copy];
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_zh_placeholder attributes:@{
//                                                                                                          NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbbbbb"]
//                                                                                                         }];
//    self.attributedPlaceholder = attrStr;
//
//}



- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {

    return [self newRect:bounds];
}

- (CGRect)newRect:(CGRect)oldRect {

    CGRect newRect = oldRect;
    newRect.origin.x = newRect.origin.x + 46;
    return newRect;
}
@end
