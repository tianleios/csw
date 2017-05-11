//
//  CSWLayoutHelper.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWLayoutHelper.h"

@implementation CSWLayoutHelper

+ (instancetype)helper {

    static CSWLayoutHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[CSWLayoutHelper alloc] init];
        [helper initData];
    });
    
    return helper;
    

}

- (void)initData {

    self.titleFont = FONT(15);
    self.contentFont = FONT(14);
    
    //
    self.contentLeftMargin = 75;
    self.contentRightMargin = 15;
    
    self.contentWidth = SCREEN_WIDTH - self.contentLeftMargin - self.contentRightMargin;
    
    //图片浏览相关
    self.photoMargin = 5;
    self.photoWidth = (self.contentWidth - 2*self.photoMargin)/3.0;
    
    //
    self.likeFont = FONT(14);
    self.commentFont = FONT(14);
    self.likeHeight = 30;
    self.likeMargin = 8;
    self.commentMargin = 3;
    self.commentTopMargin = 5;
    
}


//+ (UIFont *)titleFont {
//
//    return FONT(15);
//
//}
//
//+ (UIFont *)contentFont {
//
//    return FONT(14);
//
//}
//
//+ (CGFloat)contentLeftMargin {
//
//    return 65;
//}
//
//
//+ (CGFloat)contentWidth {
//
//    return SCREEN_WIDTH - [self contentLeftMargin] - 15;
//
//}
//
//+ (CGFloat)photoWidth {
//
//    return ([self contentWidth] - 2*[self photoMargin])/3.0;
//
//}
//
//+ (CGFloat)photoMargin {
//
//    return 5;
//
//}


@end
