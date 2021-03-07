//
//  AutodiscoveryHTMLParser.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "AutodiscoveryHTMLParser.h"

/// https://regex101.com/r/q0yQGp/4
NSString *const kRSSLinkTagRegexPattern = @"<link[^>]* rel=\"alternate\" type=\"application\\/rss\\+xml\"[^>]*>|<a[^>]*href=[^>]*title=\"(?i)RSS\"[^>]*>";
NSString *const kRSSLinkTitleTag = @"title=\"";
NSString *const kRSSLinkHrefTag = @"href=\"";

@interface AutodiscoveryHTMLParser ()
@property (nonatomic, readonly) NSRegularExpression *regExp;
@end

@implementation AutodiscoveryHTMLParser

@synthesize regExp = _regExp;

- (NSRegularExpression *)regExp {
    if (!_regExp) {
        _regExp = [[NSRegularExpression alloc] initWithPattern:kRSSLinkTagRegexPattern
                                                       options:kNilOptions
                                                         error:nil];
    }
    return _regExp;
}

- (void)dealloc {
    [_regExp release];
    [super dealloc];
}

#pragma mark - Interface

- (NSArray<NSDictionary<NSString *, NSString *> *> *)parseHTML:(NSData *)data {
    if (!data || !data.length) { return nil; }
    NSString *htmlString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSMutableArray *dictionaries = [NSMutableArray array];
    NSArray<NSTextCheckingResult *> *matchingResults = [self.regExp matchesInString:htmlString
                                                                            options:kNilOptions
                                                                              range:NSMakeRange(0, htmlString.length)];
    for (NSTextCheckingResult *match in matchingResults) {
        NSDictionary *channelDictionary = [self channelFromLinkTag:[htmlString substringWithRange:match.range]];
        if (channelDictionary) {
            [dictionaries addObject:channelDictionary];
        }
    }
    return dictionaries;
}

- (NSArray<RSSChannel *> *)parseChannelsFromHTML:(NSData *)data baseURL:(NSURL *)url {
    return [RSSChannel channelsFromDictionaries:[self parseHTML:data]
                                        baseURL:url];
}

#pragma mark - Private Methods

- (NSDictionary *)channelFromLinkTag:(NSString *)string {
    NSString *href = [self valueForTagEntry:kRSSLinkHrefTag inString:string];
    if (!href) { return nil; }
    return @{
        kRSSChannelHrefKey: href,
        kRSSChannelTitleKey: [self valueForTagEntry:kRSSLinkTitleTag inString:string]
    };
}

- (NSString *)valueForTagEntry:(NSString *)tag inString:(NSString *)string {
    NSRange tagRange = [string rangeOfString:tag];
    if (tagRange.location == NSNotFound) { return nil; }
    NSUInteger valueLocation = tagRange.location + tagRange.length;
    NSUInteger length = 0;
    for (NSUInteger i = valueLocation; i < string.length; i++) {
        if ([string characterAtIndex:i] == '"') { break; }
        length += 1;
    }
    return [string substringWithRange:NSMakeRange(valueLocation, length)];
}

@end
