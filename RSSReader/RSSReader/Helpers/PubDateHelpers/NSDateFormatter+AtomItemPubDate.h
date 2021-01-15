//
//  NSDateFormatter+AtomItemPubDate.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (AtomItemPubDate)
@property (nonatomic, class, readonly) NSDateFormatter *sharedFormatterForPubDateOutput;
@property (nonatomic, class, readonly) NSDateFormatter *sharedFormatterForPubDateInput;
@end

