//
//  NSDate+AtomItemPubDate.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <Foundation/Foundation.h>

@interface NSDate (AtomItemPubDate)
@property (nonatomic, readonly) NSString *stringForPubDate;
@end
