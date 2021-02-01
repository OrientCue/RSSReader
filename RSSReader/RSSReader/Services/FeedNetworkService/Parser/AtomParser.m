//
//  AtomParser.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "AtomParser.h"
#import "AtomFeedItem.h"
#import "NSXMLParser+AtomParser.h"

@interface AtomParser () <NSXMLParserDelegate>
@property (nonatomic, copy) FeedParserCompletion completion;
@property (nonatomic, retain) NSMutableDictionary *itemsDictionary;;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray<AtomFeedItem *> *items;
@property (nonatomic, retain) NSArray<NSString *> *keysArray;
@end

@implementation AtomParser

#pragma mark - Lifecycle

- (void)dealloc {
  [_completion release];
  [_items release];
  [_parsingString release];
  [_itemsDictionary release];
  [_keysArray release];
  [super dealloc];
}

#pragma mark - FeedParserType

- (void)parse:(NSData *)data completion:(FeedParserCompletion)completion {
  self.completion = completion;
  NSXMLParser *parser = [NSXMLParser parserWith:data delegate:self];
  [parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
  self.items = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
  if ([self.keysArray containsObject:elementName]) {
    self.parsingString = [NSMutableString string];
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
    [self addElementToItemsDictionary:elementName];
  }
  if ([elementName isEqualToString:kItemKey]) {
    [self addItem];
  }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  if (self.completion) {
    self.completion(self.items, nil);
  }
  [self resetParserState];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  if (self.completion) {
    self.completion(nil, parseError);
  }
  [self resetParserState];
}

#pragma mark - Private methods

- (void)addItem {
  AtomFeedItem *item = [AtomFeedItem itemFromDictionary:self.itemsDictionary];
  [self.items addObject:item];
  self.itemsDictionary = nil;
}

- (void)addElementToItemsDictionary:(NSString *)elementName {
  self.itemsDictionary[elementName] = self.parsingString;
  self.parsingString = nil;
}

- (void)resetParserState {
  self.completion = nil;
  self.itemsDictionary = nil;
  self.parsingString = nil;
  self.items = nil;
}

#pragma mark - Getters

- (NSMutableDictionary *)itemsDictionary {
  if (!_itemsDictionary) {
    _itemsDictionary = [NSMutableDictionary new];
  }
  return _itemsDictionary;
}

- (NSArray<NSString *> *)keysArray {
  if (!_keysArray) {
    _keysArray = [@[kTitleKey, kLinkKey, kPubDateKey, kDescriptionKey] retain];
  }
  return _keysArray;
}

@end
