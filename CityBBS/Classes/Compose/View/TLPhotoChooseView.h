//
//  TLPhotoChooseView.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPhotoChooseView : UIView

//@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, copy, getter=getImgs) NSArray <UIImage *>*imgs;

//单张选择，暂时弃用
- (void)beginChooseWithImg:(UIImage *)img;

//可传多张 【1,9】 闭区间
- (void)finishChooseWithImgs:(NSArray <UIImage *>*)imgs;

@end
