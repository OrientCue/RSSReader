//
//  AtomFeedItem.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

extern NSString *const kItemKey;
extern NSString *const kTitleKey;
extern NSString *const kDescriptionKey;
extern NSString *const kLinkKey;
extern NSString *const kPubDateKey;

@interface AtomFeedItem : NSObject
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *articleDescription;
@property (nonatomic, readonly, retain) NSURL *link;
@property (nonatomic, readonly, retain) NSDate *pubDate;

- (NSString *)pubDateString;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
