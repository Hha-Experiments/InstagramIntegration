//
//  LoginVC.m
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import "LoginVC.h"
#import "InstagramManager.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.webview setDelegate:self];
    [self loadInstagramLoginScreen];
    [self showActivityIndicator:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)loadInstagramLoginScreen {
    
    NSURL *authenticationRequestURL = [InstagramManager urlForAuthenticationRequest];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:authenticationRequestURL];
    [self.webview loadRequest:request];
}

- (void)showActivityIndicator:(BOOL)bShow {
    
    [self.activityIndicator setHidden:!bShow];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = bShow;
}

#pragma mark -- UIWebview Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* urlString = [[request URL] absoluteString];

    NSArray *UrlParts = [urlString componentsSeparatedByString:[NSString stringWithFormat:@"%@/", REDIRECT_URI]];
    
    if ([UrlParts count] > 1) {

        urlString = [UrlParts objectAtIndex:1];
        NSRange accessToken = [urlString rangeOfString: @"#access_token="];
        
        if (accessToken.location != NSNotFound) {
            
            NSString* strAccessToken = [urlString substringFromIndex: NSMaxRange(accessToken)];
            NSLog(@"AccessToken = %@ ",strAccessToken);
            
            [[NSUserDefaults standardUserDefaults] setObject:strAccessToken forKey:@"access_token"];
            
            [[InstagramManager sharedManager] setAccessToken:strAccessToken];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginVC::loginSuccessful:Notification" object:nil];
        }
        else {
            
        }
        return NO;
    }
    else {
        
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self showActivityIndicator:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == 102)
        return;
    if (error.code == -1009 || error.code == -1005)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Fail" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
	{
        NSLog(@"error: %@", error.description);
	}

    [self showActivityIndicator:NO];
}

@end
