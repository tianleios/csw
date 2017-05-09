//
//  TLBannerCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLDisplayBannerCell.h"
#import "TLBannerView.h"
#import "CSWBannerModel.h"

@interface TLDisplayBannerCell()


@end

@implementation TLDisplayBannerCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bannerView = [[TLBannerView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.bannerView];
//        self.bannerView .imgUrls = @[@"http://a3.topitme.com/e/49/3f/11768840385b63f49el.jpg",
//                                     @"http://a4.topitme.com/l/201101/01/12938831439644.jpg",
//                                     @"http://a4.topitme.com/l/201101/01/12938817885985.jpg"];
        
        __weak typeof(self) weakSelf = self;
        //选中事件
        [self.bannerView setSelected:^(NSInteger index){
            
              CSWBannerModel *bannerModel =  weakSelf.bannerRoom[index];
            
              //根据url跳转
//              bannerModel.url
        }];
        
    }
    
    return self;
    
}

+ (NSString *)reuseId {

    return @"tlBannerCellId";
    
}

- (void)setBannerRoom:(NSArray<CSWBannerModel *> *)bannerRoom {

    _bannerRoom = [bannerRoom copy];
    
    NSMutableArray *pics = [[NSMutableArray alloc] initWithCapacity:_bannerRoom.count];
    [_bannerRoom enumerateObjectsUsingBlock:^(CSWBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLBannerModel *banner = [TLBannerModel new];
        banner.imgUrl = [obj.pic convertImageUrl];
        banner.title = obj.name;
        [pics addObject:banner];
    }];
    self.bannerView.bannerRooms = pics;

}

@end
