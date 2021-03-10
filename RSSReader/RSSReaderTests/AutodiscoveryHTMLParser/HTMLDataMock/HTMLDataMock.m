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
        id bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"html" ofType:@"bundle"];
        _bundle = [[NSBundle bundleWithPath:bundlePath] retain];
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
    return [self htmlData:@"tut_by"];
}

- (NSData *)onliner_by {
    return [self htmlData:@"onliner_by"];
}

- (NSData *)nytimes_com {
    return [self htmlData:@"nytimes_com"];
}

#pragma mark -

- (NSData *)htmlData:(NSString *)filename {
    NSString *fileUrl = [self.bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:fileUrl];
    return data;
}

@end
