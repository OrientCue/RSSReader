//
//  AtomFeedItem.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "AtomFeedItem.h"
#import "NSDate+AtomItemPubDate.h"
#import "NSString+AtomItemPubDate.h"

NSString *const kItemKey = @"item";
NSString *const kTitleKey = @"title";
NSString *const kDescriptionKey = @"description";
NSString *const kLinkKey = @"link";
NSString *const kPubDateKey = @"pubDate";

@implementation AtomFeedItem

- (instancetype)initWithTitle:(NSString *)title
           articleDescription:(NSString *)articleDescription
                         link:(NSURL *)link
                      pubDate:(NSDate *)pubDate {
  if (self = [super init]) {
    _title = title ? [title copy] : [@"" copy];
    _articleDescription = articleDescription ? [articleDescription copy] : [@"" copy];
    _link = link ? [link retain] : [NSURL new];
    _pubDate = pubDate ? [pubDate retain] : [[NSDate date] retain];
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title
           articleDescription:(NSString *)articleDescription
                   linkString:(NSString *)linkString
                pubDateString:(NSString *)pubDateString {
  return [self initWithTitle:title
          articleDescription:articleDescription
                        link:[NSURL URLWithString:linkString]
                     pubDate:pubDateString.dateForPubDateString];
}

+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary {
  if (!dictionary) {
    [NSException raise:NSInvalidArgumentException format:@"Dictionary parameter should not be nil!"];
  }
  if (!dictionary.count) {
    [NSException raise:NSInvalidArgumentException format:@"Dictionary parameter should not be empty!"];
  }
  return [[[AtomFeedItem alloc] initWithTitle:dictionary[kTitleKey]
                           articleDescription:dictionary[kDescriptionKey]
                                   linkString:dictionary[kLinkKey]
                                pubDateString:dictionary[kPubDateKey]] autorelease];
}

#pragma mark - Lifecycle

- (instancetype)init {
  return [self initWithTitle:nil
          articleDescription:nil
                        link:nil
                     pubDate:nil];
}

- (void)dealloc {
  [_title release];
  [_articleDescription release];
  [_link release];
  [_pubDate release];
  [super dealloc];
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"Title: %@\nLink: %@\nPubDate: %@",
          self.title,
          self.link.absoluteString,
          self.pubDate];
}

#pragma mark - Interface

- (NSString *)pubDateString {
  return self.pubDate.stringForPubDate;
}

@end
