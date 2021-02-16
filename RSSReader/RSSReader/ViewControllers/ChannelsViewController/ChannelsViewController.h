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
typedef void(^DisplayErrorHandler)(NSError *error);

@interface ChannelsViewController : UIViewController <ChannelsViewType>
@property (nonatomic, copy) DidTapAddButtonHandler didTapAddButtonHandler;
@property (nonatomic, copy) DidSelectChannelHandler didSelectChannelHandler;
@property (nonatomic, copy) DisplayErrorHandler displayErrorHandler;
- (instancetype)initWithPresenter:(id<ChannelsPresenterType>)presenter;
@end
