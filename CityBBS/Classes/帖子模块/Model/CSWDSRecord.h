//
//  CSWDSRecord.h
//  CityBBS
//
//  Created by  tianlei on 2017/4/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CSWDSRecord : TLBaseModel

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *postCode;


@end
