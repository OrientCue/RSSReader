//
//  NSString+RR_HTMLTags.m
//  RSSReader
//
//  Created by Arseniy Strakh on 04.12.2020.
//

#import "NSString+RR_HTMLTags.h"

NSString *const kRegExpTagPattern = @"<[^>]+>";

@implementation NSString (RR_HTMLTags)

- (NSString *)descriptionWOTagsIfPresent {
    return [self stringByReplacingOccurrencesOfString:kRegExpTagPattern
                                           withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, self.length)];
}

@end
