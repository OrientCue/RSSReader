//
//  NSString+RR_HTMLTags.m
//  RSSReader
//
//  Created by Arseniy Strakh on 04.12.2020.
//

#import "NSString+RR_HTMLTags.h"

NSString *const kEndTag = @"<br clear=\"all\" />";
NSString *const kStartTag = @"/>";

@implementation NSString (RR_HTMLTags)

- (NSString *)descriptionWOTagsIfPresent {
  NSRange endTag = [self rangeOfString:kEndTag];
  if (endTag.location == NSNotFound) {
    return self;
  }
  NSRange startTag = [self rangeOfString:kStartTag];
  NSUInteger start = startTag.location + startTag.length;
  NSUInteger end = endTag.location;
  return [self substringWithRange:NSMakeRange(start, end - start)];
}

@end
