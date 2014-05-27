//
//  EENApi.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENAPI.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface EENAPI ()

@property (nonatomic, strong) NSDateFormatter *eenTimestampFormatter;
@property (nonatomic, strong) NSHTTPCookie *sessionCookie;

@end

@implementation EENAPI

+ (instancetype)client {
    static EENAPI *_apiClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiClient = [[EENAPI alloc] initWithBaseURL:[NSURL URLWithString:kEENAPIBaseURLString]];
        _apiClient.eenTimestampFormatter = [[NSDateFormatter alloc] init];
        _apiClient.eenTimestampFormatter.dateFormat = @"yyyyMMddHHmmss.SSS";
    });
    return _apiClient;
}

- (void)authenticateWithUsername:(NSString *)username
                            password:(NSString *)password
                             success:(EENGenericBlock)success
                             failure:(EENErrorBlock)failure {
    NSDictionary *parameters = @{ @"username": username,
                                  @"password": password,
                                  @"realm": kEENAPIRealm };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@g/aaa/authenticate", kEENAPIBaseURLString]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
              success(response[@"token"]);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
}

- (void)authorizeUserWithToken:(NSString *)token
                       success:(EENGenericBlock)success
                       failure:(EENErrorBlock)failure {
    NSDictionary *parameters = @{ @"token": token };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@g/aaa/authorize", kEENAPIBaseURLString]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:operation.response.allHeaderFields
                                                                        forURL:operation.response.URL];
              if (cookies.count > 0) {
                  self.sessionCookie = cookies[0];
                  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookies[0]];
              }
              success(responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
}

@end
