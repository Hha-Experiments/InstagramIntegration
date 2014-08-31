//
//  PhotoVC.m
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import "PhotoVC.h"
#import "InstagramManager.h"

#define kCellIdentifier @"PhotoCell"

@interface PhotoVC ()

@end

@implementation PhotoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonAction)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(loadUserInstagramImages)];
    self.navigationItem.rightBarButtonItem=refreshButton;
    
    self.imageArray = [[NSMutableArray alloc] init];
    [self loadUserInstagramImages];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)loadUserInstagramImages {
    
    [self showActivityIndicator:YES];
    
    [[InstagramManager sharedManager] getUserInstagramImagesWithSuccess:^(NSArray *imageArray) {
        
        [self.imageArray removeAllObjects];
        self.imageArray = [NSMutableArray arrayWithArray:imageArray];
        [self.collectionView reloadData];
        [self showActivityIndicator:NO];
        
    } orFailure:^(NSError *error) {
        
        [self showActivityIndicator:NO];
        
    }];
}

- (void)logoutButtonAction {
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:BASE_URL]];
    
    for (NSHTTPCookie* cookie in instagramCookies)
    {
        [cookies deleteCookie:cookie];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActivityIndicator:(BOOL)bShow {

    [self.activityIndicator setHidden:!bShow];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = bShow;
}

#pragma mark - UICollectionView Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
	return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [(UIImageView*)[cell viewWithTag:13463] setImage:[UIImage imageNamed:@"loading"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSDictionary *imageDict = [self.imageArray objectAtIndex:indexPath.item];
        NSString *strImageUrl = imageDict[@"images"][@"standard_resolution"][@"url"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImageUrl]];
        
        UIImage *image = nil;
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        else {
            image = [UIImage imageNamed:@"loading"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView *imageView = (UIImageView*)[cell viewWithTag:13463];
            [imageView setImage:image];
            [imageView.layer setCornerRadius:1.5];
            [imageView.layer setBorderWidth:1];
            [imageView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
            [imageView.layer setShadowOffset:CGSizeMake(1, 2)];
            [imageView.layer setShadowRadius:2];
            [imageView.layer setShadowOpacity:0.9];
            [imageView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
            
            UIView *photoBackground = (UIView*)[cell viewWithTag:690000];
            [photoBackground.layer setCornerRadius:1.5];
            [photoBackground.layer setBorderWidth:1];
            [photoBackground.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        });
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(160, 160);
}

@end
