//
//  ChannelsViewController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <UIKit/UIKit.h>
#import "ChannelsViewType.h"
#import "ChannelsPresenterType.h"

@class RSSChannel;
typedef void(^DidSelectChannelHandler)(RSSChannel *channel);
typedef void(^DidTapAddButtonHandler)(void);

@interface ChannelsViewController : UIViewController <ChannelsViewType>
@property (nonatomic, copy) DidTapAddButtonHandler didTapAddButtonHandler;
@property (nonatomic, copy) DidSelectChannelHandler didSelectChannelHandler;
- (instancetype)initWithPresenter:(id<ChannelsPresenterType>)presenter;
@end
