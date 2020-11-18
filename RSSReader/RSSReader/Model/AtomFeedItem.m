//
//  AtomFeedItem.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "AtomFeedItem.h"

NSString *const kItemKey = @"item";
NSString *const kTitleKey = @"title";
NSString *const kEnclosureKey = @"enclosure";
NSString *const kDescriptionKey = @"description";
NSString *const kURLKey = @"url";
NSString *const kLinkKey = @"link";
NSString *const kPubDateKey = @"pubDate";

@implementation AtomFeedItem

#pragma mark - NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (!dictionary || !dictionary.count) { return nil; }
  if (self = [super init]) {
    _title = dictionary[kTitleKey] ? [dictionary[kTitleKey] copy] : [@"" copy];
    _articleDescription = dictionary[kDescriptionKey] ? [dictionary[kDescriptionKey] copy] : [@"" copy];
    _link = [[NSURL URLWithString:dictionary[kLinkKey]] retain];
    _pubDate = [[self dateFrom:dictionary[kPubDateKey]] retain];
  }
  return self;
}

- (void)dealloc {
  [_title release];
  [_articleDescription release];
  [_link release];
  [_pubDate release];
  [super dealloc];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Title: %@\nLink: %@\nPubDate: %@", self.title, self.link.absoluteString, self.pubDate];
}

#pragma mark - Interface

- (NSString *)pubDateString {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"MM.dd.yyyy HH:mm";
  NSString *rv = [df stringFromDate:self.pubDate];
  [df release];
  return rv;
}

#pragma mark - Private Methods

- (NSDate *)dateFrom:(NSString *)string {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"EE, d MMM yyyy HH:mm:ss Z";
  NSDate *date = [df dateFromString:string];
  [df release];
  return date;
}

@end
