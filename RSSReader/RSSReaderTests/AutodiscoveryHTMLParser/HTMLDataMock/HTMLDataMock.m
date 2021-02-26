//
//  HTMLDataMock.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "HTMLDataMock.h"

@interface HTMLDataMock ()
@property (nonatomic, retain) NSBundle *bundle;
@end

@implementation HTMLDataMock

#pragma mark - Object Lifecycle

- (NSBundle *)bundle {
    if (!_bundle) {
        _bundle = [[NSBundle bundleForClass:[self class]] retain];
    }
    return _bundle;
}

- (void)dealloc {
    [_bundle release];
    [super dealloc];
}

#pragma mark -

- (NSData *)meduza_io {
    return [self htmlData:@"withoutTags"];
}

- (NSData *)tut_by {
    return [self htmlData:@"tut.by"];
}

- (NSData *)onliner_by {
    return [self htmlData:@"onliner.by"];
}

- (NSData *)nytimes_com {
    return [self htmlData:@"nytimes.com"];
}

#pragma mark -

- (NSData *)htmlData:(NSString *)filename {
    NSURL *fileUrl = [self.bundle URLForResource:filename withExtension:@"html"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    return data;
}

@end
