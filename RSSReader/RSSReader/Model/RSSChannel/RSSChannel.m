//
//  RSSChannel.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "RSSChannel.h"

NSString *const kRSSChannelKey = @"channel";
NSString *const kRSSChannelTitleKey = @"title";
NSString *const kRSSChannelHrefKey = @"href";

@implementation RSSChannel

#pragma mark - Object Lifecycle

- (instancetype)initWithTitle:(NSString *)title link:(NSURL *)link {
    if (self = [super init]) {
        _title = [title copy];
        _link = [link retain];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_link release];
    [super dealloc];
}

+ (NSArray<RSSChannel *> *)channelsFromDictionaries:(NSArray *)dictionaries baseURL:(NSURL *)url;{
    NSMutableArray *channels = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        NSString *href = [dictionary[kRSSChannelHrefKey] localizedLowercaseString];
        if (!href) { continue; }
        NSURL *link = [NSURL URLWithString:href relativeToURL:url];
        RSSChannel *channel = [[[RSSChannel alloc] initWithTitle:dictionary[kRSSChannelTitleKey]
                                                            link:link] autorelease];
        [channels addObject:channel];
    }
    return [[channels copy] autorelease];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return true;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
    [coder encodeObject:self.link forKey:NSStringFromSelector(@selector(link))];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _title = [[coder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))] retain];
        _link = [[coder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(link))] retain];
    }
    return self;
}


#pragma mark - <NSObject>

- (NSString *)description {
    return [NSString stringWithFormat:@"Channel:\nTitle: %@\nLink: %@", self.title, self.link];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return true;
    }
    if (![other isKindOfClass:[RSSChannel class]]) {
        return false;
    }
    return [self isEqualToChannel:other] ;
}

- (BOOL)isEqualToChannel:(RSSChannel *)channel {
    return [self.link.absoluteString isEqualToString:channel.link.absoluteString];
}

- (NSUInteger)hash {
    return self.link.hash;
}

@end
