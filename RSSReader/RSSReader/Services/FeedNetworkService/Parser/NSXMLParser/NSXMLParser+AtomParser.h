//
//  NSXMLParser+AtomParser.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <Foundation/Foundation.h>

@interface NSXMLParser (AtomParser)
+ (NSXMLParser *)parserWith:(NSData *)data delegate:(id<NSXMLParserDelegate>)delegate;
@end
