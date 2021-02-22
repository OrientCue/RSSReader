//
//  RSSChannelParser.m
//  RSSReader
//
//  Created by Arseniy Strakh on 29.12.2020.
//

#import "RSSChannelParser.h"
#import "NSXMLParser+AtomParser.h"
#import "AtomFeedItem.h"

@interface RSSChannelParser () <NSXMLParserDelegate>
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableDictionary *channelDictionary;
@property (nonatomic, copy) RSSChannelParserCompletion completion;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end

@implementation RSSChannelParser

#pragma mark - Object Lifecycle

- (void)dealloc {
    [_baseURL release];
    [_parser release];
    [_parsingString release];
    [_channelDictionary release];
    [_completion release];
    [super dealloc];
}

#pragma mark -

- (void)parse:(NSData *)data baseURL:(NSURL *)url completion:(RSSChannelParserCompletion)completion {
    self.baseURL = url;
    self.completion = completion;
    self.parser = [NSXMLParser parserWith:data delegate:self];
    [self.parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([kRSSChannelKey isEqualToString:elementName] ||
        [kRSSChannelTitleKey isEqualToString:elementName]) {
        self.parsingString = [NSMutableString string];
    }
    if ([kItemKey isEqualToString:elementName]) {
        self.finished = true;
        [parser abortParsing];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if (self.parsingString) {
        self.channelDictionary[elementName] = self.parsingString;
        self.parsingString = nil;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.isFinished && self.completion) {
        RSSChannel *channel = [[[RSSChannel alloc] initWithTitle:self.channelDictionary[kRSSChannelTitleKey]
                                                            link:self.baseURL] autorelease];
        self.completion(channel, nil);
    } else if (self.completion) {
        self.completion(nil, parseError);
    }
    [self resetState];
}

- (void)resetState {
    self.baseURL = nil;
    self.parser = nil;
    self.parsingString = nil;
    self.channelDictionary = nil;
    self.completion = nil;
}

#pragma mark - Getters

- (NSMutableDictionary *)channelDictionary {
    if (!_channelDictionary) {
        _channelDictionary = [NSMutableDictionary new];
    }
    return _channelDictionary;
}

@end
