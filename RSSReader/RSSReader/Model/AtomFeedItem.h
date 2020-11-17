//
//  AtomFeedItem.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

extern NSString *const kItemKey;
extern NSString *const kTitleKey;
extern NSString *const kEnclosureKey;
extern NSString *const kDescriptionKey;
extern NSString *const kURLKey;
extern NSString *const kLinkKey;
extern NSString *const kPubDateKey;

@interface AtomFeedItem : NSObject
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *articleDescription;
@property (nonatomic, readonly) NSURL *link;
@property (nonatomic, readonly) NSDate *pubDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
