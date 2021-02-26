//
//  AutodiscoveryHTMLParser.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

@interface AutodiscoveryHTMLParser : NSObject
- (NSArray<NSDictionary<NSString *, NSString *> *> *)parseHTML:(NSData *)data;
- (NSArray<RSSChannel *> *)parseChannelsFromHTML:(NSData *)data baseURL:(NSURL *)url;
@end
