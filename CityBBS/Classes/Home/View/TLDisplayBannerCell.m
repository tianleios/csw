//
//  TLBannerCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLDisplayBannerCell.h"
#import "TLBannerView.h"

@interface TLDisplayBannerCell()

@property (nonatomic, strong) TLBannerView *bannerView;

@end

@implementation TLDisplayBannerCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bannerView = [[TLBannerView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.bannerView];
        self.bannerView .imgUrls = @[@"http://a3.topitme.com/e/49/3f/11768840385b63f49el.jpg",
                                     @"http://a4.topitme.com/l/201101/01/12938831439644.jpg",
                                     @"http://a4.topitme.com/l/201101/01/12938817885985.jpg"];
        
    }
    return self;
}

+ (NSString *)reuseId {

    return @"tlBannerCellId";
    
}


@end
