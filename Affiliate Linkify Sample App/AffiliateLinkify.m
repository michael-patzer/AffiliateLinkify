//
//  AffiliateLinkify.m
//  Affiliate Linkify Sample App
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import "AffiliateLinkify.h"
#import "NSString+Additions.h"

NSString *const kiTunesDomain = @"itunes.apple.com";
NSString *const kPhobosDomain = @"phobos.apple.com";
NSString *const kAffiliateKey = @"at";
NSString *const kCampaignKey = @"ct";
NSString *const kAmpersand = @"&";
NSString *const kEquals = @"=";
NSString *const kQuestionMark = @"?";

@implementation AffiliateLinkify

#pragma mark - Internal App Store

- (void)openInternalAppStoreWithURL:(NSURL *)url
                 fromViewController:(UIViewController *)viewController delegate:(id<SKStoreProductViewControllerDelegate>)delegate {
    if (![[self class] isValidURL:url]) {
        NSLog(@"AffiliateLinkify: Cannot open internal app store. URL is not a valid iTunes URL.");
        return;
    }
    
    url = [[self class] affiliateURLFromURL:url];
    _rootViewController = viewController;
    _delegate = delegate;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request
                                  delegate:self];
}

#pragma mark - Valid URL

+ (BOOL)isValidURL:(NSURL *)url {
    return ([url.host hasSuffix:kiTunesDomain] ||
            [url.host hasSuffix:kPhobosDomain]);
}

#pragma mark - Convert URL

+ (NSURL *)affiliateURLFromURL:(NSURL *)url {
    if (![self isValidURL:url]) {
        NSLog(@"AffiliateLinkify: URL cannot be converted to an affiliate link.");
        return url;
    }
    return [self createURLFromURL:url withAffiliateCode:kAffiliateCode andCampaignId:nil];
}

+ (NSURL *)createURLFromURL:(NSURL *)url
          withAffiliateCode:(NSString *)affiliateCode
              andCampaignId:(NSString *)campaignId {
    if (![self isValidURL:url]) return url;
    
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryFromURL:url]];
    
    if (affiliateCode) {
        if ([queryDictionary objectForKey:kAffiliateKey]) {
            NSLog(@"AffiliateLinkify: URL already contains an affiliate code: %@. Replacing with new code: %@", [queryDictionary objectForKey:kAffiliateKey], affiliateCode);
        }
        [queryDictionary setObject:affiliateCode forKey:kAffiliateKey];
    }
    else {
        [queryDictionary removeObjectForKey:kAffiliateKey];
    }
    
    if (campaignId) {
        if ([queryDictionary objectForKey:kCampaignKey]) {
            NSLog(@"AffiliateLinkify: URL already contains a campaign ID: %@. Replacing with new ID: %@", [queryDictionary objectForKey:kCampaignKey], campaignId);
        }
        [queryDictionary setObject:campaignId forKey:kCampaignKey];
    }
    else {
        [queryDictionary removeObjectForKey:kCampaignKey];
    }
    
    // Reassemble query string
    NSString *queryString = [self queryStringFromParameters:queryDictionary];
    
    NSString *finalURLString = [NSString stringWithFormat:@"%@://%@%@%@%@", url.scheme, url.host, url.path, kQuestionMark, queryString];
    return [NSURL URLWithString:finalURLString];
}

#pragma mark - Query String

+ (NSDictionary *)dictionaryFromURL:(NSURL *)url {
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *queryElements = [url.query componentsSeparatedByString:kAmpersand];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:kEquals];
        if (keyVal.count >= 2) {
            NSString *key = [keyVal objectAtIndex:0];
            NSString *value = [keyVal objectAtIndex:1];
            [queryDict setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:key];
        }
    }
    return queryDict;
}

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in parameters) {
        id value = parameters[key];
        if ([value isKindOfClass:[NSString class]]) {
            [parts addObject:[NSString stringWithFormat:@"%@%@%@", key, kEquals, [value urlEncode]]];
        }
        else {
            [parts addObject:[NSString stringWithFormat:@"%@%@%@", key, kEquals, value]];
        }
    }
    
    return [parts componentsJoinedByString:kAmpersand];
}

#pragma mark - iTunes URL Parsing

+ (NSString *)storeItemIdentifierForURL:(NSURL *)URL {
    NSString *itemIdentifier;
    if ([URL.host hasSuffix:kiTunesDomain]) {
        NSString *lastPathComponent = [[URL path] lastPathComponent];
        if ([lastPathComponent hasPrefix:SKStoreProductParameterITunesItemIdentifier]) {
            itemIdentifier = [lastPathComponent substringFromIndex:2];
        }
        else {
            itemIdentifier = [[self dictionaryFromURL:URL] objectForKey:SKStoreProductParameterITunesItemIdentifier];
        }
    }
    else if ([URL.host hasSuffix:kPhobosDomain]) {
        itemIdentifier = [[self dictionaryFromURL:URL] objectForKey:SKStoreProductParameterITunesItemIdentifier];
    }
    
    NSCharacterSet *nonIntegers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (itemIdentifier && itemIdentifier.length > 0 && [itemIdentifier rangeOfCharacterFromSet:nonIntegers].location == NSNotFound) {
        return itemIdentifier;
    }
    
    return nil;
}

#pragma mark - <NSURLConnectionDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response {
    // Step 1: Save the most recent response URL as the redirect URL in case multiple redirects occur.
    // Step 2: If the response URL or request URL are valid iTunes URLs, cancel the connection and finish loading. Otherwise, continue to send the request.
    
    NSURL *responseURL = [response URL];
    if (responseURL) {
        _redirectURL = responseURL;
    }
    
    if ([[self class] isValidURL:_redirectURL]) {
        [connection cancel];
        [self connectionDidFinishLoading:connection];
        return nil;
    }
    else {
        NSURL *requestURL = [request URL];
        if ([[self class] isValidURL:requestURL]) {
            _redirectURL = requestURL;
            [connection cancel];
            [self connectionDidFinishLoading:connection];
            return nil;
        }
        
        return request;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSURL *iTunesURL = _redirectURL;
    
    if ([[self class] isValidURL:iTunesURL]) {
        NSString *iTunesIdentifier = [[self class] storeItemIdentifierForURL:iTunesURL];
        SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
        [controller setDelegate:_delegate];
        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:iTunesIdentifier};
        [controller loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [_rootViewController presentViewController:controller animated:YES completion:^{
                    NSLog(@"AffiliateLinkify: Internal app store presented successfully.");
                }];
            }
            else {
                NSLog(@"AffiliateLinkify: App store failed to load url. %@", [error localizedDescription]);
            }
        }];
    }
    else {
        NSLog(@"AffiliateLinkify: Final URL in redirect was not an iTunes URL.");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"AffiliateLinkify: App store connection failed. %@", [error localizedDescription]);
}

@end
