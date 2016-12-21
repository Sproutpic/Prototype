//
//  SyncQueue.h
//  Sprout
//
//  Created by Jeff Morris on 11/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncAllData.h"

@class SproutWebService;

@interface SyncQueue : NSObject

+ (SyncQueue*)manager;

- (void)addService:(SproutWebService*)service;
- (void)emptyQueue;

- (BOOL)isServiceTagQueued:(NSString*)serviceTag;


@end
