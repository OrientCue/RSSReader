//
//  SettingsStore.h
//  RSSReader
//
//  Created by Arseniy Strakh on 21.12.2020.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

@interface SettingsStore : NSObject <NSSecureCoding>
@property (nonatomic, retain) NSArray<RSSChannel *> *channels;
@property (nonatomic) NSInteger selectedChannel;
@end
