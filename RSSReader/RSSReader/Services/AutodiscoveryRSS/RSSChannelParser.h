//
//  RSSChannelParser.h
//  RSSReader
//
//  Created by Arseniy Strakh on 29.12.2020.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

typedef void(^RSSChannelParserCompletion)(RSSChannel *channel, NSError *error);

@interface RSSChannelParser : NSObject
- (void)parse:(NSData *)data
      baseURL:(NSURL *)url
   completion:(RSSChannelParserCompletion)completion;
@end
