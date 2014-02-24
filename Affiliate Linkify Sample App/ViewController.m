//
//  ViewController.m
//  Affiliate Linkify Sample App
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+AffiliateLinkify.h"
#import "AffiliateLinkify.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _iTunesLink = @"https://itunes.apple.com/us/app/apple-store/id375380948";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)externalAppButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:_iTunesLink];
    [[UIApplication sharedApplication] openAffiliateURL:url];
}

- (IBAction)internalAppButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:_iTunesLink];
    AffiliateLinkify *affiliateLinkify = [[AffiliateLinkify alloc] init];
    [affiliateLinkify openInternalAppStoreWithURL:url
                               fromViewController:self
                                         delegate:self];
}

#pragma mark <SKStoreProductViewControllerDelegate>

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
