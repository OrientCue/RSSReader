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
@property (nonatomic, retain) NSMutableDictionary *parsingDictionary;
@property (nonatomic, retain) NSMutableDictionary *itemsDictionary;;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation AtomParser

- (void)dealloc {
  [_completion release];
  [_items release];
  [_parsingString release];
  [_parsingDictionary release];
  [_itemsDictionary release];
  [super dealloc];
}

- (void)parse:(NSData *)data completion:(FeedParserCompletion)completion {
  self.completion = completion;
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
  parser.delegate = self;
  [parser parse];
  [parser release];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  if (self.completion) {
    self.completion(nil, parseError);
  }
  [self resetParserState];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
  self.items = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//  NSLog(@"\n\n%s", __PRETTY_FUNCTION__);
//  NSLog(@"elementName: %@\nnamespaceURI: %@\nqName: %@\nattributeDict: %@\n", elementName, namespaceURI, qName, attributeDict);
  if ([elementName isEqualToString:kTitleKey]) {
    self.parsingString = [NSMutableString string];
  } else if ([elementName isEqualToString:kLinkKey]) {
    self.parsingString = [NSMutableString string];
  } else if ([elementName isEqualToString:kPubDateKey]) {
    self.parsingString = [NSMutableString string];
  } else if ([elementName isEqualToString:kDescriptionKey]) {
    self.parsingString = [NSMutableString string];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//  NSLog(@"%s", __PRETTY_FUNCTION__);
//  NSLog(@"%@", string);
  [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
//  NSLog(@"%s", __PRETTY_FUNCTION__);
//  NSLog(@"elementName: %@\nnamespaceURI: %@\nqName: %@\n\n", elementName, namespaceURI, qName);
  if (self.parsingString) {
    [self.parsingDictionary setObject:self.parsingString forKey:elementName];
    [_parsingString release];
    _parsingString = nil;
  }
  if ([elementName isEqualToString:@"item"]) {
    AtomFeedItem *item = [[AtomFeedItem alloc] initWithDictionary:self.itemsDictionary];
    [self.items addObject:item];
    [item release];
    [_itemsDictionary release];
    _itemsDictionary = nil;
    [_parsingDictionary release];
    _parsingDictionary = nil;
  } else {
//    NSLog(@"%@", elementName);
    [self.itemsDictionary addEntriesFromDictionary:self.parsingDictionary];
  }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  if (self.completion) {
    self.completion(self.items, nil);
  }
  [self resetParserState];
}

#pragma mark - Private methods

- (void)resetParserState {
  [_completion release];
  _completion = nil;
  [_items release];
  _items = nil;
  [_parsingDictionary release];
  _parsingDictionary = nil;
  [_parsingString release];
  _parsingString = nil;
}

#pragma mark - Getters

- (NSMutableDictionary *)parsingDictionary {
  if (!_parsingDictionary) {
    _parsingDictionary = [NSMutableDictionary new];
  }
  return _parsingDictionary;
}

- (NSMutableDictionary *)itemsDictionary {
  if (!_itemsDictionary) {
    _itemsDictionary = [NSMutableDictionary new];
  }
  return _itemsDictionary;
}

@end
