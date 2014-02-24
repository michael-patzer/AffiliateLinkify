//
//  NSString+Additions.h
//  Affiliate Linkify Sample App
//
//  Created by Mike Patzer on 2/20/14.
//  Copyright (c) 2014 Patzer LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (BOOL)containsString:(NSString *)substring;
- (NSString *)urlEncode;

@end
