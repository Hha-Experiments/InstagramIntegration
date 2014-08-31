//
//  LoginVC.h
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UIWebViewDelegate>

@property IBOutlet UIWebView *webview;
@property IBOutlet UIActivityIndicatorView *activityIndicator;

@end
