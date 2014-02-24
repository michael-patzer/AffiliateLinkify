//
//  UIApplication+AffiliateLinkify.m
//  Affiliate Linkify Sample App
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import "UIApplication+AffiliateLinkify.h"
#import "AffiliateLinkify.h"

@implementation UIApplication (AffiliateLinkify)

- (BOOL)openAffiliateURL:(NSURL *)url {
    url = [AffiliateLinkify affiliateURLFromURL:url];
    return [[UIApplication sharedApplication] openURL:url];
}

@end
