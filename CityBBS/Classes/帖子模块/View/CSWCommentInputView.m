//
//  CSWCommentInputView.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentInputView.h"

@interface CSWCommentInputView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *inputTextView;

@end

@implementation CSWCommentInputView


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        //发表
    }
    
    return NO;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.inputTextView = [[UITextView alloc] init];
        
        [self addSubview:self.inputTextView];
        self.inputTextView.returnKeyType = UIReturnKeySend;
        self.inputTextView.delegate = self;
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.right.equalTo(self.mas_right).offset(-100);
            
        }];
        
        self.inputTextView.backgroundColor = [UIColor lineColor];
        
    }
    return self;
}

@end
