//
//  AtomItemCellDelegate.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.11.2020.
//

#import <Foundation/Foundation.h>

@protocol AtomItemCellDelegate <NSObject>
- (void)row:(NSInteger)row expandedState:(BOOL)isExpanded;
@end
