//
//  AffiliateLinkify.h
//  Affiliate Linkify Sample App
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKStoreProductViewController.h>

#warning Replace the affiliate code below with your own affiliate code.
#define kAffiliateCode @"11l599"

@interface AffiliateLinkify : NSObject <NSURLConnectionDelegate> {
    NSURL *_redirectURL;
    UIViewController *_rootViewController;
    id <SKStoreProductViewControllerDelegate> _delegate;
}

#pragma mark - Internal App Store
- (void)openInternalAppStoreWithURL:(NSURL *)url
                 fromViewController:(UIViewController *)viewController
                           delegate:(id<SKStoreProductViewControllerDelegate>)delegate;

#pragma mark - Validity & Conversion methods
+ (BOOL)isValidURL:(NSURL *)url;
+ (NSURL *)affiliateURLFromURL:(NSURL *)url;

#pragma mark - Custom Affiliate Code & Campaign Id
+ (NSURL *)createURLFromURL:(NSURL *)url
          withAffiliateCode:(NSString *)affiliateCode
              andCampaignId:(NSString *)campaignId;

@end
