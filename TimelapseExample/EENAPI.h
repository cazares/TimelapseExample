//
//  EENApi.h
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>

static NSString * const kEENAPIBaseURLString = @"https://login.eagleeyenetworks.com";
static NSString * const kEENAPIRealm = @"eagleeyenetworks";

@interface EENAPI : AFHTTPSessionManager

typedef void (^EENEmptyBlock)();
typedef void (^EENGenericBlock)(id);
typedef void (^EENErrorBlock)(NSError *);

+ (instancetype)client;

- (void)authenticateWithUsername:(NSString *)username
                            password:(NSString *)password
                             success:(EENGenericBlock)success
                             failure:(EENErrorBlock)failure;

- (void)authorizeUserWithToken:(NSString *)token
                       success:(EENGenericBlock)success
                       failure:(EENErrorBlock)failure;

- (void)getDeviceListWithSuccess:(EENEmptyBlock)success
                         failure:(EENErrorBlock)failure;

@property (nonatomic, strong) NSArray *cameraIDList;
@property (nonatomic, strong) NSArray *cameraNameList;

@end
