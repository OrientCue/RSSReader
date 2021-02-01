//
//  ChannelsLocalStorageService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import "ChannelsLocalStorageService.h"
#import "SettingsStore.h"
#import "RSSChannel.h"

@interface ChannelsLocalStorageService ()
@property (nonatomic, readonly) NSURL *fileURL;
@property (nonatomic, retain) SettingsStore *store;
@property (nonatomic, copy) LocalStorageUpdateListenerHandler handler;
@end

@implementation ChannelsLocalStorageService

@synthesize fileURL = _fileURL;

static NSString *const kSettingsFileName = @"com.arss.rssreader.settings.dat";

#pragma mark - Object Lifecycle

- (id)copy {
    return self;
}

- (void)dealloc {
  [_store release];
  [_handler release];
  [super dealloc];
}

+ (instancetype)shared {
  static ChannelsLocalStorageService *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [ChannelsLocalStorageService new];
  });
  
  return shared;
}

#pragma mark - MRC

- (oneway void)release {
    
}

- (instancetype)autorelease {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (instancetype)retain {
    return self;
}

#pragma mark - Lazy Properties

- (NSURL *)fileURL {
  if (!_fileURL) {
    NSURL *documentsURL = [[NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory
                                                                inDomains:NSUserDomainMask] firstObject];
    _fileURL = [[documentsURL URLByAppendingPathComponent:kSettingsFileName] retain];
  }
  return _fileURL;
}

- (SettingsStore *)store {
  if (!_store) {
    _store = [SettingsStore new];
  }
  return _store;
}

#pragma mark -

- (SettingsStore *)loadSavedStoreError:(NSError **)error {
  NSData *data = [NSData dataWithContentsOfURL:self.fileURL
                                       options:NSDataReadingMapped
                                         error:error];
  if (*error) {
    return nil;
  } else {
    self.store = [NSKeyedUnarchiver unarchivedObjectOfClass:[SettingsStore class]
                                                   fromData:data
                                                      error:error];
    return *error ? nil : self.store;
  }
}

- (BOOL)containsChannel:(RSSChannel *)channel {
  return [self.store.channels containsObject:channel];
}

- (BOOL)removeChannel:(RSSChannel *)channel error:(NSError **)error {
  NSMutableArray *channels = [[self.store.channels mutableCopy] autorelease];
  [channels removeObject:channel];
  self.store.channels = [[channels copy] autorelease];
  if (self.store.selectedChannel >= self.store.channels.count) {
    self.store.selectedChannel = self.store.channels.count - 1;
  }
  [self saveStoreError:error];
  [self notifyListeners];
  return error && *error ? false : true;
}

- (BOOL)updateStoreWithSelected:(NSUInteger)index error:(NSError **)error {
  self.store.selectedChannel = index;
  [self saveStoreError:error];
  return error && *error ? false : true;
}

#pragma mark -

- (BOOL)saveStoreError:(NSError **)error{
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.store
                                       requiringSecureCoding:true
                                                       error:error];
  [data writeToURL:self.fileURL options:NSDataWritingAtomic error:error];
  return error && *error ? false : true;
}

- (BOOL)addChannels:(NSArray<RSSChannel *> *)channels lastSelected:(BOOL)selected error:(NSError **)error {
  self.store.channels = [self.store.channels arrayByAddingObjectsFromArray:channels];
  if (selected) { self.store.selectedChannel = self.store.channels.count - 1; }
  [self saveStoreError:error];
  [self notifyListeners];
  return error && *error ? false : true;
}

#pragma mark -

- (void)addListenerHandler:(LocalStorageUpdateListenerHandler)handler {
  self.handler = handler;
}

- (void)notifyListeners {
  if (self.handler) { self.handler(); }
}

@end
