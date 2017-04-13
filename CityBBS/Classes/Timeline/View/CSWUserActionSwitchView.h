//
//  CSWUserActionSwitchView.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSWUserActionSwitchDelegate <NSObject>

- (void)didSwitch:(NSInteger)idx;

@end

@interface CSWUserActionSwitchView : UIView

- (instancetype)init;

@property (nonatomic, weak) id<CSWUserActionSwitchDelegate> delegate;
@property (nonatomic, copy) NSArray <NSString *>*countStrRoom;


@end
