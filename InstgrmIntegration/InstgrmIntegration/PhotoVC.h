//
//  PhotoVC.h
//  InstgrmIntegration
//
//  Created by H.h.Aung on 31/8/14.
//  Copyright (c) 2014 hha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property IBOutlet UICollectionView *collectionView;
@property IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSMutableArray *imageArray;

@end
