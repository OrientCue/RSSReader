//
//  SettingsStore.m
//  RSSReader
//
//  Created by Arseniy Strakh on 21.12.2020.
//

#import "SettingsStore.h"

@implementation SettingsStore

#pragma mark - Object Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _channels = [NSArray new];
    }
    return self;
}

#pragma mark -

- (void)setSelectedChannel:(NSInteger)selectedChannel {
    if (!self.channels.count) {
        _selectedChannel = 0;
    } else if (selectedChannel >= self.channels.count) {
        _selectedChannel = self.channels.count - 1;
    } else {
        _selectedChannel = selectedChannel;
    }
}

#pragma mark -

+ (BOOL)supportsSecureCoding {
    return true;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.selectedChannel forKey:NSStringFromSelector(@selector(selectedChannel))];
    [coder encodeObject:self.channels forKey:NSStringFromSelector(@selector(channels))];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _selectedChannel = [coder decodeIntegerForKey:NSStringFromSelector(@selector(selectedChannel))];
        _channels = [coder decodeObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [RSSChannel class]]]
                                           forKey:NSStringFromSelector(@selector(channels))];
    }
    return self;
}

@end
