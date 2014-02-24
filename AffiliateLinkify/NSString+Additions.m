//
//  NSString+Additions.m
//  Affiliate Linkify Sample App
//
//  Created by Mike Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL)containsString:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    return (range.location != NSNotFound);
}

- (NSString *)urlEncode {
    static CFStringRef toEscape = CFSTR(":/=,!$&'()*+;[]@#?");
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				 (__bridge CFStringRef)self,
																				 NULL,
																				 toEscape,
																				 kCFStringEncodingUTF8);
}

@end
