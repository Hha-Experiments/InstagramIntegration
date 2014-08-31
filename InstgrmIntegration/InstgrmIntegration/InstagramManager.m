//
//  InstagramManager.m
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import "InstagramManager.h"

@implementation InstagramManager

+ (InstagramManager*) sharedManager {
	static InstagramManager *__sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[InstagramManager alloc] init];
    });
    return __sharedManager;
}

- (void)getUserInstagramImagesWithSuccess:(void(^)(NSArray *imageArray))success orFailure:(void(^)(NSError *error))failure {
    
    NSData *data = [NSData dataWithContentsOfURL: [InstagramManager urlForRecentMediaRequest:self.accessToken]];
    
    NSError *error = nil;
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        failure(error);
        return;
    }
    
    NSLog(@"Response : %@",dictResponse);
    
    NSArray *mediaArray = dictResponse[@"data"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *mediaDict in mediaArray) {
        
        if ([mediaDict[@"type"] caseInsensitiveCompare:@"image"] == NSOrderedSame) {
            
            [imageArray addObject:mediaDict];
        }
    }
    
    success(imageArray);
}

- (void)getUserInfoWithSuccess:(void(^)(NSArray *imageArray))success orFailure:(void(^)(NSError *error))failure {

    NSData *data = [NSData dataWithContentsOfURL: [InstagramManager urlForUserInfoRequest:self.accessToken]];
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Response : %@",dictResponse);
    
    NSArray *mediaArray = dictResponse[@"data"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *mediaDict in mediaArray) {
        
        if ([mediaDict[@"type"] caseInsensitiveCompare:@"image"] == NSOrderedSame) {
            
            [imageArray addObject:mediaDict];
        }
    }
}

+ (NSArray*)getInstagramCookies {
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://instagram.com/"]];
    
    return instagramCookies;
}

+ (NSURL*)urlForAuthenticationRequest {

    NSString *strUrl = [NSString stringWithFormat:@"%@%@client_id=%@&redirect_uri=%@", API_BASE_URL, AUTHENTICATE, CLIENT_ID, REDIRECT_URI];
    return [NSURL URLWithString:strUrl];
}

+ (NSURL*)urlForUserInfoRequest:(NSString*)access_token {

    NSString *strUrl = [NSString stringWithFormat:@"%@%@access_token=%@", API_BASE_URL, SELF_INFO, access_token];
    return [NSURL URLWithString:strUrl];
}

+ (NSURL*)urlForRecentMediaRequest:(NSString*)access_token {

   NSString *strUrl = [NSString stringWithFormat:@"%@%@access_token=%@", API_BASE_URL, SELF_MEDIA, access_token];
    return [NSURL URLWithString:strUrl];
}

@end

