//
//  AutodiscoveryHTMLParserType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 27.02.2021.
//

#import <Foundation/Foundation.h>

@class RSSChannel;
@protocol AutodiscoveryHTMLParserType <NSObject>
@property (nonatomic, retain, readonly) NSRegularExpression *regExp;
- (NSArray<RSSChannel *> *)parseChannelsFromHTML:(NSData *)html baseURL:(NSURL *)url;
- (NSArray<NSDictionary<NSString *, NSString *> *> *)parseHTML:(NSData *)data;
@end
