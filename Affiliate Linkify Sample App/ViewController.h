//
//  ViewController.h
//  Affiliate Linkify Sample App
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>

@interface ViewController : UIViewController <SKStoreProductViewControllerDelegate> {
    NSString *_iTunesLink;
}

- (IBAction)externalAppButtonPressed:(id)sender;
- (IBAction)internalAppButtonPressed:(id)sender;

@end
