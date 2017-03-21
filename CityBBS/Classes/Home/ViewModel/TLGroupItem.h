//
//  TLGroupItem.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLGroupItem : NSObject

//尺寸
//边距
@property  Class cellClass;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSInteger cellNumber;
@property (nonatomic, assign) NSInteger minimumLineSpacing;
@property (nonatomic, assign) NSInteger minimumInteritemSpacing;



@end
