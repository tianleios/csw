//
//  UIImage+TLAdd.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UIImage+TLAdd.h"

@implementation UIImage (TLAdd)

- (NSString *)getUploadImgName {

    if (!self) {
        NSLog(@"图片不能为nil");
        return nil;
    }
    CGSize imgSize = self.size;//
    
    NSDate *now = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%f",now.timeIntervalSince1970];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *imageName = [NSString stringWithFormat:@"iOS_%@_%.0f_%.0f.jpg",timestamp,imgSize.width,imgSize.height];
    
    return imageName;
    

}


@end
