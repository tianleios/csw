//
//  CSWArticleModel.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleModel.h"
#import "AppConfig.h"
#import "CSWLayoutHelper.h"

@implementation CSWArticleModel


+ (NSDictionary *)mj_objectClassInArray {

    return @{@"commentList" : [CSWCommentModel class],
             @"likeList" : [CSWLikeModel class],
             };

}

- (NSArray *)thumbnailUrls {

    if (self.picArr.count > 9) {
        self.picArr = [self.picArr subarrayWithRange:NSMakeRange(0, 9)];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.picArr.count];
    [self.picArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //重要优化，列表要取足够小的缩略图，输出--》 获取足够小的正方形图片
        NSString *imgDomain = [AppConfig config].qiniuDomain;
        
      
        CGFloat photoW_PX = [CSWLayoutHelper helper].photoWidth * [UIScreen mainScreen].scale;
        
        //imageView2/1/w/50/h/50/format/jpg/q/75|imageslim
        //
        //imageMogr2/gravity/Center/crop/300x300

        //先缩略，在截取正中心 正方形
//       imageMogr2/auto-orient/strip/thumbnail/!100x100r/gravity/Center/crop/100x100
        
         NSString *imgSizeThumbnailXXXX = [NSString stringWithFormat:@"!%fx%fr",photoW_PX,photoW_PX];
        
        NSString *imgSizeCropXXXX = [NSString stringWithFormat:@"%fx%f",photoW_PX,photoW_PX];
        
        
        NSString *imgUrlStr =
        [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip/thumbnail/%@/gravity/Center/crop/%@",imgDomain,obj,imgSizeThumbnailXXXX,imgSizeCropXXXX]
         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [arr addObject:imgUrlStr];
    }];
    return arr;

}

- (NSArray *)originalUrls {

    if (self.picArr.count > 9) {
        self.picArr = [self.picArr subarrayWithRange:NSMakeRange(0, 9)];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.picArr.count];
    [self.picArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        [arr addObject:[obj convertImageUrlWithScale:100]];
        
    }];
    return arr;
    

}


//- (NSArray<CSWCommentModel *> *)comments {
//    
//    //tianlei自己单独评论
//    CSWCommentModel *model1 = [CSWCommentModel new];
//    model1.commentUserId = @"tianlei";
//    model1.commentContent=  @"评论好难";
//    
//    CSWCommentModel *model11 = [CSWCommentModel new];
//    model11.userId = @"tianlei";
//    model11.commentText=  @"评论好评论好难评评论好难评论评论好难评论评论好难评论论好难评论好难评论好难评论好难评论好难评论好难难";
//    
//    //tianlei 回复 lww
//    CSWCommentModel *model2 = [CSWCommentModel new];
//    model2.userId = @"tianlei";
//    model2.reUserId = @"lww";
//    model2.reCommentText = @"我不觉得娜娜的vfdsfdsfjlsjlkfjkldsfl收费的方式的";
//    
//    CSWCommentModel *model3 = [CSWCommentModel new];
//    model3.userId = @"tianlei";
//    model3.reUserId = @"lww";
//    model3.reCommentText = @"我不觉得娜娜的娜的vfdsfdsfjl娜的vfdsfdsfjl娜的vfdsfdsfjlvfdsfdsfjlsjlkfjkldsfl收费的方式的";
//    
//    CSWCommentModel *model4 = [CSWCommentModel new];
//    model4.userId = @"tianlei";
//    model4.reUserId = @"lww";
//    model4.reCommentText = @"555555我不觉得娜娜的vfdsfdsfjlsjlkfjkldsfl收费的方式的";
//    
//    CSWCommentModel *model5 = [CSWCommentModel new];
//    model5.userId = @"tianlei";
//    model5.reUserId = @"lww";
//    model5.reCommentText = @"666666我不觉得娜娜的vfdsfdsfjlsjlkfjkldsfl收费的方式的";
//    
//    CSWCommentModel *model6 = [CSWCommentModel new];
//    model6.userId = @"tianlei";
//    model6.reUserId = @"lww";
//    model6.reCommentText = @"我不觉得娜娜的vfdsfdsfjlsjlkfjkldsfl收费的方式的";
//    
//    return @[model1,model11,model2,model3,model4,model5];
//}

//-(NSArray *)dzArray {
//
//    if (1) {
//        return @[@"田lei",@"lww",@"你们好",@"你们好",@"你们好",@"你们好"];
//
//    } else {
//    
//        return @[];
//    }
//
//}
//- (NSString *)title {
//
//    return @"Xcode 甚至能够与 Apple 开发者网站通信,因此您只需点击一下够与 Apple 开发者网站通信,因此您只需点击一下";
//}
//
//- (NSString *)content {
//
//    return @"Xcode @121313 @田磊[微笑][可爱][微笑][可爱][微笑][可爱]甚至能够与 Apple 开发者网站通信,因此您只需点击一下";
//
//}
//
//- (NSArray *)photos {
//
//    NSInteger count =  10;
//    if (count == 1) {
//        return @[@"http://a3.topitme.com/e/49/3f/11768840385b63f49el.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938831439644.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938817885985.jpg"];
//    } else if(count == 0){
//    
//        return @[@"http://a3.topitme.com/e/49/3f/11768840385b63f49el.jpg"
//                 ];
//    
//    } else {
//    
//        return @[@"http://a3.topitme.com/e/49/3f/11768840385b63f49el.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938831439644.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938817885985.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938817885985.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938831439644.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938817885985.jpg",
//                 @"http://a4.topitme.com/l/201101/01/12938831439644.jpg"
//
//                 ];
//    }
// 
//
//}
@end
