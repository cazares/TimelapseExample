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
@property (nonatomic, strong) AFHTTPRequestOperationManager *jsonRequestHttpResponseManager;

@end

@implementation EENAPI

+ (instancetype)client {
    static EENAPI *_apiClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiClient = [[EENAPI alloc] initWithBaseURL:[NSURL URLWithString:kEENAPIBaseURLString]];
        _apiClient.eenTimestampFormatter = [[NSDateFormatter alloc] init];
        _apiClient.eenTimestampFormatter.dateFormat = @"yyyyMMddHHmmss.SSS";
        _apiClient.jsonRequestHttpResponseManager = [AFHTTPRequestOperationManager manager];
        _apiClient.jsonRequestHttpResponseManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _apiClient.jsonRequestHttpResponseManager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
    [self.jsonRequestHttpResponseManager POST:[NSString stringWithFormat:@"%@/g/aaa/authenticate", kEENAPIBaseURLString]
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
    [self.jsonRequestHttpResponseManager POST:[NSString stringWithFormat:@"%@/g/aaa/authorize", kEENAPIBaseURLString]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:operation.response.allHeaderFields
                                                                        forURL:operation.response.URL];
              if (cookies.count > 0) {
                  self.sessionCookie = cookies[0];
                  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookies[0]];
              }
              NSError *error;
              NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
              success(response);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
}

- (void)getDeviceListWithSuccess:(EENEmptyBlock)success
                         failure:(EENErrorBlock)failure {
    // specify device type of camera
    NSDictionary *parameters = @{ @"t": @"camera" };
    [self.jsonRequestHttpResponseManager GET:[NSString stringWithFormat:@"%@/g/device/list", kEENAPIBaseURLString]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // see https://apidocs.eagleeyenetworks.com/apidocs/#!/device/deviceList_get_4 for indexing of subarrays and parsing
             // more information from the /device/list api call
             NSMutableArray *cameraIDs = [NSMutableArray array];
             NSMutableArray *cameraNames = [NSMutableArray array];
             NSError *error;
             NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
             for (NSArray *subarray in response) {
                 [cameraIDs addObject:subarray[1]];
                 [cameraNames addObject:subarray[2]];
             }
             self.cameraIDList = cameraIDs;
             self.cameraNameList = cameraNames;
             success();
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}

@end
