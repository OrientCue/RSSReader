//
//  NSXMLParser+AtomParser.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "NSXMLParser+AtomParser.h"

@implementation NSXMLParser (AtomParser)

+ (NSXMLParser *)parserWith:(NSData *)data delegate:(id<NSXMLParserDelegate>)delegate {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = delegate;
    return [parser autorelease];
}

@end
