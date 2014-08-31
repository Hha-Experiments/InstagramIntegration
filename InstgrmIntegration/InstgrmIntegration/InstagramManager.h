//
//  InstagramManager.h
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL        @"https://instagram.com/"
#define API_BASE_URL    @"https://api.instagram.com/"
#define AUTHENTICATE    @"oauth/authorize/?response_type=token&"
#define SELF_INFO       @"v1/users/self/?"
#define SELF_MEDIA      @"v1/users/self/media/recent/?"

#define CLIENT_ID       @"YOUR_CLIENT_ID"
#define CLIENT_SECRET   @"YOUR_CLIENT_SECRET"
#define WEBSITE_URL     @"http://localhost"
#define REDIRECT_URI	@"http://localhost"

@interface InstagramManager : NSObject

@property (nonatomic, strong) NSString* accessToken;

+ (InstagramManager*)sharedManager;
+ (NSArray*)getInstagramCookies;
+ (NSURL*)urlForAuthenticationRequest;
+ (NSURL*)urlForUserInfoRequest:(NSString*)access_token;
+ (NSURL*)urlForRecentMediaRequest:(NSString*)access_token;

- (void)getUserInfoWithSuccess:(void(^)(NSArray *imageArray))success orFailure:(void(^)(NSError *error))failure;
- (void)getUserInstagramImagesWithSuccess:(void(^)(NSArray *imageArray))success orFailure:(void(^)(NSError *error))failure;

@end
