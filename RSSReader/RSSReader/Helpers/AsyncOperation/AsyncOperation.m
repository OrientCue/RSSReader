//
//  AsyncOperation.m
//  TED Talks Videos
//
//  Created by Arseniy Strakh on 17.07.2020.
//  Copyright © 2020 Arseniy Strakh. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation () {
  BOOL executing;
  BOOL finished;
}
@end

@implementation AsyncOperation

- (BOOL)isAsynchronous {
  return YES;
}

- (BOOL)isExecuting {
  return executing;
}

- (BOOL)isFinished {
  return finished;
}

- (void)start {
  if (self.isCancelled) {
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    return;
  }
  [self main];
  [self willChangeValueForKey:@"isExecuting"];
  executing = YES;
  [self didChangeValueForKey:@"isExecuting"];

}

- (void)finishOperation {
  [self willChangeValueForKey:@"isExecuting"];
  [self willChangeValueForKey:@"isFinished"];
  executing = NO;
  finished = YES;
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}

@end
