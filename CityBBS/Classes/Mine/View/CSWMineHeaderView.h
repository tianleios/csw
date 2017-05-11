//
//  CSWMineHeaderVC.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    MineHeaderSeletedTypeDefault = 0,
    MineHeaderSeletedTypeFlow
};

@protocol CSWMineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx;

@end

@interface CSWMineHeaderView : UIView

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *levelLbl;
@property (nonatomic, weak) id<CSWMineHeaderSeletedDelegate> delegate;


//
@property (nonatomic, strong) NSNumber *articelNum;
@property (nonatomic, strong) NSNumber *fansNum;
@property (nonatomic, strong) NSNumber *focusNum;
//@property (nonatomic, strong) NSNumber *sjNum;

@property (nonatomic, copy) NSString *sjNumText;



@property (nonatomic, copy) NSArray <NSNumber *>*numberArray;

- (void)reset;


@end
