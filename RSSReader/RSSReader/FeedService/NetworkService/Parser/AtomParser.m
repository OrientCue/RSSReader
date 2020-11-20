//
//  AtomParser.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "AtomParser.h"
#import "AtomFeedItem.h"

@interface AtomParser () <NSXMLParserDelegate>
@property (nonatomic, copy) FeedParserCompletion completion;
@property (nonatomic, retain) NSMutableDictionary *itemsDictionary;;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray<AtomFeedItem *> *items;
@end

@implementation AtomParser

- (void)dealloc {
  [_completion release];
  [_items release];
  [_parsingString release];
  [_itemsDictionary release];
  [super dealloc];
}

- (void)parse:(NSData *)data completion:(FeedParserCompletion)completion {
  assert(completion);
  self.completion = completion;
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
  parser.delegate = self;
  [parser parse];
  [parser release];
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
  NSArray<NSString *> *keysArray = @[kTitleKey, kLinkKey, kPubDateKey, kDescriptionKey];
  if ([keysArray containsObject:elementName]) {
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
    self.itemsDictionary[elementName] = self.parsingString;
    [self resetParsingString];
  }
  if ([elementName isEqualToString:kItemKey]) {
    [self addItem];
    [self resetItemsDictionary];
  }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  self.completion(self.items, nil);
  [self resetParserState];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  self.completion(nil, parseError);
  [self resetParserState];
}

#pragma mark - Private methods

- (void)addItem {
  AtomFeedItem *item = [[AtomFeedItem alloc] initWithDictionary:self.itemsDictionary];
  if (item) {
    [self.items addObject:item];
  }
  [item release];
}

- (void)resetParserState {
  [_completion release];
  _completion = nil;
  [self resetItemsDictionary];
  [self resetParsingString];
}

- (void)resetParsingString {
  [_parsingString release];
  _parsingString = nil;
}

- (void)resetItemsDictionary {
  [_itemsDictionary release];
  _itemsDictionary = nil;
}

#pragma mark - Getters

- (NSMutableDictionary *)itemsDictionary {
  if (!_itemsDictionary) {
    _itemsDictionary = [NSMutableDictionary new];
  }
  return _itemsDictionary;
}

@end
