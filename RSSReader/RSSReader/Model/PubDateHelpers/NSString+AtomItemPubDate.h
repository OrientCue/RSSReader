//
//  NSString+AtomItemPubDate.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <Foundation/Foundation.h>

@interface NSString (AtomItemPubDate)
@property (nonatomic, readonly) NSDate *dateForPubDateString;
@end

