//
//  ViewController.m
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import "ViewController.h"
#import "InstagramManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *instagramCookies = [InstagramManager getInstagramCookies];
    if (instagramCookies.count > 0) {
        
        NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        [[InstagramManager sharedManager] setAccessToken:strAccessToken];
        [self showPhotoVC];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessfulNotificaitonReceived) name:@"LoginVC::loginSuccessful:Notification" object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)showPhotoVC {
    
    [self performSegueWithIdentifier:@"PhotoVC" sender:self];
}

- (void)loginSuccessfulNotificaitonReceived {
    
    [self.navigationController popViewControllerAnimated:NO];
    [self showPhotoVC];
}

@end
