//
//  CSWCommentLayoutItem.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentLayoutItem.h"
#import "CSWLayoutHelper.h"
#import "TLEmoticonHelper.h"
#import "MLLinkLabel.h"
#define CONST_TOP_HEIGHT 60


static MLLinkLabel * kProtypeLabel() {
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = [CSWLayoutHelper helper].contentFont;
        _protypeLabel.numberOfLines = 0;
        
        //        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _protypeLabel.lineHeightMultiple = 1.2f;
    });
    return _protypeLabel;
}

@implementation CSWCommentLayoutItem


- (void)setCommentModel:(CSWCommentModel *)commentModel {

    _commentModel = commentModel;
    
    
    //回复的评论
    if (_commentModel.parentCommentUserNickname) {
        
        NSString *contentStr = [NSString stringWithFormat:@"回复 %@ :%@",_commentModel.parentCommentUserNickname,_commentModel.content];
        
      NSMutableAttributedString *tempAttr =  [[NSMutableAttributedString alloc] initWithAttributedString:[TLEmoticonHelper convertEmoticonStrToAttributedString:contentStr]];
     [tempAttr addAttribute:NSLinkAttributeName value:_commentModel.parentCommentUserNickname range:NSMakeRange(3, _commentModel.parentCommentUserNickname.length)];
        
     self.commentAttrStr = tempAttr;
        
        
        
    } else {
    //单人发出评论
    
        self.commentAttrStr = [TLEmoticonHelper convertEmoticonStrToAttributedString:_commentModel.content];
    
    
    }
    
    MLLinkLabel *testLabel = kProtypeLabel();
    testLabel.attributedText = self.commentAttrStr;
    
    CGFloat contenW = SCREEN_WIDTH - 70 - 15;
    CGSize contenSize = [testLabel sizeThatFits:CGSizeMake(contenW, MAXFLOAT)];
    self.commentFrame = CGRectMake(70, CONST_TOP_HEIGHT, contenSize.width, contenSize.height);
    
    //
    //    CSWLayoutHelper *layout = [CSWLayoutHelper helper];
    //    CGSize size = [_commentModel.content calculateStringSize:CGSizeMake(SCREEN_WIDTH - 70 - 15, MAXFLOAT) font:layout.contentFont];
    //    self.commentFrame = CGRectMake(70, CONST_TOP_HEIGHT, size.width, size.height);
    
    //
    self.cellHeight = CGRectGetMaxY(self.commentFrame) + 10;
    
   
    
    
 
    
}

@end
