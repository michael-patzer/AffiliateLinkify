//
//  Affiliate_Linkify_Sample_AppTests.m
//  Affiliate Linkify Sample AppTests
//
//  Created by Michael Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AffiliateLinkify.h"

@interface Affiliate_Linkify_Sample_AppTests : XCTestCase {
    NSString *_standardURL;
    NSString *_affiliateURL;
    NSString *_otherAffiliateURL;
    NSString *_affiliateCampaignURL;
    NSString *_phobosURL;
    NSString *_foreignURL;
    NSString *_noParameterURL;
    NSString *_wrongBaseURL;
    NSString *_noIdURL;
    NSString *_falseIdURL;
    
    NSString *_simpleURL;
    NSString *_simpleLinkified;
}

@end

@implementation Affiliate_Linkify_Sample_AppTests

- (void)setUp
{
    [super setUp];
    
    _standardURL = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413?ls=1&mt=8";
    _affiliateURL = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413?ls=1&mt=8&at=11l599";
    _otherAffiliateURL = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413?ls=1&mt=8&at=567890";
    _affiliateCampaignURL = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413?at=11l599&ct=12345&ls=1&mt=8";
    _phobosURL = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=585130595&mt=8";
    _foreignURL = @"https://itunes.apple.com/cn/app/travel-altimeter-gps-altitude/id453389413?ls=1&mt=8";
    _noParameterURL = @"https://itunes.apple.com/cn/app/travel-altimeter-gps-altitude/id453389413";
    _wrongBaseURL = @"http://google.com/us/app/travel-altimeter-gps-altitude/id453389413?ls=1&mt=8";
    _noIdURL = @"";
    _falseIdURL = @"";
    
    _simpleURL = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413";
    _simpleLinkified = @"https://itunes.apple.com/us/app/travel-altimeter-gps-altitude/id453389413?at=11l599";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testURLValidity
{
    XCTAssertTrue([AffiliateLinkify isValidURL:[NSURL URLWithString:_standardURL]], @"Method fails on standard URL.");
    XCTAssertTrue([AffiliateLinkify isValidURL:[NSURL URLWithString:_affiliateURL]], @"Method fails on affiliate URL.");
    XCTAssertTrue([AffiliateLinkify isValidURL:[NSURL URLWithString:_phobosURL]], @"Method fails on phobos URL.");
    XCTAssertTrue([AffiliateLinkify isValidURL:[NSURL URLWithString:_foreignURL]], @"Method fails on foreign URL.");
    XCTAssertTrue([AffiliateLinkify isValidURL:[NSURL URLWithString:_noParameterURL]], @"Method fails on standard URL with no parameters.");
    
    XCTAssertFalse([AffiliateLinkify isValidURL:[NSURL URLWithString:_wrongBaseURL]], @"Method passed a URL with wrong base URL.");
}

- (void)testConvertURL {
    XCTAssertEqualObjects([AffiliateLinkify affiliateURLFromURL:[NSURL URLWithString:_standardURL]], [NSURL URLWithString:_affiliateURL], @"Standard URL not converted to an affiliate link.");
    
    XCTAssertEqualObjects([AffiliateLinkify affiliateURLFromURL:[NSURL URLWithString:_simpleURL]], [NSURL URLWithString:_simpleLinkified], @"Simple URL not converted to an affiliate link.");
    
    XCTAssertEqualObjects([AffiliateLinkify affiliateURLFromURL:[NSURL URLWithString:_otherAffiliateURL]], [NSURL URLWithString:_affiliateURL], @"Method did not replace existing affiliate code, or link was assembled incorrectly.");
}

- (void)testCreateAffiliateURL {
    XCTAssertEqualObjects([AffiliateLinkify createURLFromURL:[NSURL URLWithString:_standardURL] withAffiliateCode:kAffiliateCode andCampaignId:@"12345"], [NSURL URLWithString:_affiliateCampaignURL], @"Campaign ID and/or affiliate code were not appended, and/or link was assembled incorrectly.");
}

@end
