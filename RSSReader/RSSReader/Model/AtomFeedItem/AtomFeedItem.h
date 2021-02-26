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
@property (nonatomic, readonly, strong) NSURL *link;
@property (nonatomic, readonly, strong) NSDate *pubDate;

@property (nonatomic, readonly) NSString *pubDateString;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title
           articleDescription:(NSString *)articleDescription
                         link:(NSURL *)link
                      pubDate:(NSDate *)pubDate NS_DESIGNATED_INITIALIZER;

/// Creates AtomFeedItem from dictionary with AtomFeedItem string keys.  Will raise invalidArgumentException for nil or empty dictionary.
/// @param dictionary NSDictionary with AtomFeedItems keys.
+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary;
@end
