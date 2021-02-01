//
//  RSSChannel.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <Foundation/Foundation.h>

extern NSString *const kRSSChannelKey;
extern NSString *const kRSSChannelTitleKey;
extern NSString *const kRSSChannelHrefKey;

@interface RSSChannel : NSObject <NSSecureCoding>
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSURL *link;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;;

- (instancetype)initWithTitle:(NSString *)title link:(NSURL *)link;
+ (NSArray<RSSChannel *> *)channelsFromDictionaries:(NSArray *)dictionaries
                                            baseURL:(NSURL *)url;
@end
