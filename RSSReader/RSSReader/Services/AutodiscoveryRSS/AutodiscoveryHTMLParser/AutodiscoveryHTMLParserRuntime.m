//
//  AutodiscoveryHTMLParserRuntime.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.02.2021.
//

// -fobjc-arc

#import <objc/message.h>
#import "AutodiscoveryHTMLParserRuntime.h"
#import "RSSChannel.h"

Class AutodiscoveryHTMLParserRuntime;

const int kClassVersion = 1;

#pragma mark -

char *const kClassName = "AutodiscoveryHTMLParserRuntime";
char *const kRegExpIvarName = "_regExp";
char *const kPropertyTypeEncodingAttribute = "T";
char *const kPropertyBackingIVarNameAttribute = "V";
char *const kPropertyNonAtomicAttribute = "N";
char *const kPropertyReadOnlyAttribute = "R";
char *const kPropertyRetainAttribute = "&";

#pragma mark -

NSString *const kRSSLinkTitleTag = @"title=\"";
NSString *const kRSSLinkHrefTag = @"href=\"";
/// https://regex101.com/r/q0yQGp/4
NSString *const kRSSLinkTagRegexPattern = @"<link[^>]* rel=\"alternate\" type=\"application\\/rss\\+xml\"[^>]*>|<a[^>]*href=[^>]*title=\"(?i)RSS\"[^>]*>";

#pragma mark - Register Runtime Class

void _registerHTMLParserClass(void);

void registerHTMLParserClass(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _registerHTMLParserClass();
    });
}

#pragma mark - _registerHTMLParserClass

static void addRegExpReadonlyProperty(void);
static void addParseHTMLWithBaseURLMethod(void);
static NSArray<NSDictionary *> *parseHTML(id self, SEL _cmd, NSData *html);

void _registerHTMLParserClass(void) {
    AutodiscoveryHTMLParserRuntime = objc_allocateClassPair([NSObject class], kClassName, 0);
    addRegExpReadonlyProperty();
    addParseHTMLWithBaseURLMethod();
    class_addMethod(AutodiscoveryHTMLParserRuntime, @selector(parseHTML:), (IMP)parseHTML, "@@:@");
    class_addProtocol(AutodiscoveryHTMLParserRuntime, @protocol(AutodiscoveryHTMLParserType));
    class_setVersion(AutodiscoveryHTMLParserRuntime, kClassVersion);
    objc_registerClassPair(AutodiscoveryHTMLParserRuntime);
}

#pragma mark - RegExp Property

static NSRegularExpression *getRegExp(id self, SEL _cmd) {
    Ivar regexpIvar = class_getInstanceVariable(AutodiscoveryHTMLParserRuntime, kRegExpIvarName);
    id regExp = object_getIvar(self, regexpIvar);
    if (!regExp) {
        regExp = [NSRegularExpression regularExpressionWithPattern:kRSSLinkTagRegexPattern
                                                           options:0
                                                             error:nil];
        object_setIvar(self, regexpIvar, regExp);
    }
    return regExp;
}

///    regExp    T@"NSRegularExpression",R,&,N,V_regExp
static void addRegExpReadonlyProperty() {
    class_addIvar(AutodiscoveryHTMLParserRuntime,
                  kRegExpIvarName,
                  sizeof(id),
                  log2(sizeof(id)),
                  @encode(id));
    objc_property_attribute_t type = { kPropertyTypeEncodingAttribute, @encode(id) };
    objc_property_attribute_t ownership = { kPropertyRetainAttribute, "" };
    objc_property_attribute_t access = { kPropertyReadOnlyAttribute, "" };
    objc_property_attribute_t backingIvar  = { kPropertyBackingIVarNameAttribute, kRegExpIvarName };
    objc_property_attribute_t atomicity  = { kPropertyNonAtomicAttribute, "" };
    objc_property_attribute_t attributes[] = { type, atomicity, ownership, access, backingIvar };
    class_addProperty(AutodiscoveryHTMLParserRuntime,
                      [NSStringFromSelector(@selector(regExp)) UTF8String],
                      attributes,
                      sizeof(attributes) / sizeof(objc_property_attribute_t));
    class_addMethod(AutodiscoveryHTMLParserRuntime, @selector(regExp), (IMP)getRegExp, "@@:");
}

#pragma mark - ParseHTMLWithBaseURL

static void addParseHTMLWithBaseURLMethod() {
    IMP parseChannelsImp = imp_implementationWithBlock(^id (id self, NSData *data, NSURL *url) {
        id dictionaries = [self parseHTML:data];
        return [RSSChannel channelsFromDictionaries:dictionaries baseURL:url];
    });
    class_addMethod(AutodiscoveryHTMLParserRuntime, @selector(parseChannelsFromHTML:baseURL:), parseChannelsImp, "@@:@@");
}

#pragma mark - parseHTML

NSDictionary *channelFromLinkTag(NSString *string);
NSString *valueForTagEntry(NSString *tag, NSString *string);

static NSArray<NSDictionary *> *parseHTML(id self, SEL _cmd, NSData *html) {
    if (!html || !html.length) { return nil; }
    NSString *htmlString = [[NSString alloc] initWithData:html encoding:NSUTF8StringEncoding];
    NSMutableArray *returnValue = [NSMutableArray array];
    NSArray<NSTextCheckingResult *> *matchingResults = [[self regExp] matchesInString:htmlString
                                                                              options:0
                                                                                range:NSMakeRange(0, htmlString.length)];
    for (NSTextCheckingResult *match in matchingResults) {
        NSDictionary *channel = channelFromLinkTag([htmlString substringWithRange:match.range]);
        if (channel) {
            [returnValue addObject:channel];
        }
    }
    return [returnValue copy];
}

#pragma mark - Private Methods

NSString *valueForTagEntry(NSString *tag, NSString *string) {
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

NSDictionary *channelFromLinkTag(NSString *string) {
    NSString *href = valueForTagEntry(kRSSLinkHrefTag, string);
    if (!href) { return nil; }
    return @{
        kRSSChannelHrefKey: href,
        kRSSChannelTitleKey: valueForTagEntry(kRSSLinkTitleTag, string)
    };
}

