//
//  AutodiscoveryRSS.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <Foundation/Foundation.h>
#import "SearchChannelsServiceType.h"

typedef void(^AutodiscoveryCompletion)(NSArray *channels, NSError *error);

@interface AutodiscoveryRSS : NSObject <SearchChannelsServiceType>
@end
