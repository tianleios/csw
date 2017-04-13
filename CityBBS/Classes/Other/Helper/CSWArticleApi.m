//
//  CSWArticleApi.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleApi.h"

@implementation CSWArticleApi

+ (void)reportArticleWithArticleCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610113";
    http.parameters[@"code"] = code;
    http.parameters[@"reporter"] = userId;
    http.parameters[@"reportNote"] = reportNote;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];


}

+ (void)reportCommentWithCommentCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610113";
    http.parameters[@"code"] = code;
    http.parameters[@"reporter"] = userId;
    http.parameters[@"reportNote"] = reportNote;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
    
}


+ (void)collectionArticleWithCode:(NSString *)code
                            user:(NSString *)userId
                             success:(void(^)())success
                             failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
}

+ (void)dzArticleWithCode:(NSString *)code
                         user:(NSString *)userId
                          success:(void(^)())success
                          failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
    
}

@end
