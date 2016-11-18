//
//  SyncQueue.m
//  Sprout
//
//  Created by Jeff Morris on 11/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SyncQueue.h"
#import "SproutWebService.h"

static SyncQueue *shared = nil;

@interface SyncQueue ()

@property (strong, nonatomic) NSMutableArray *queue;
@property (nonatomic) BOOL paused;
@property (strong, nonatomic) SproutWebService *currentService;
@property (strong, nonatomic) SproutServiceCallBack serviceCallBack;

@end

@implementation SyncQueue

# pragma mark Public

+ (SyncQueue*)manager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[SyncQueue alloc] init];
        shared.paused = NO;
        shared.queue = [@[] mutableCopy];
    });
    return shared;
}

- (void)addService:(SproutWebService*)service
{
    if (service) {
        [[self queue] addObject:service];
    }
    [self processQueue];
}

- (void)emptyQueue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self queue] removeAllObjects];
        [self setCurrentService:nil];
        [self setServiceCallBack:nil];
    });
}

# pragma mark Private

- (void)processQueue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self paused] && ![self currentService] && [[self queue] count]>0) {
            [self setCurrentService:[[self queue]  firstObject]];
            [self setServiceCallBack:[[self currentService] serviceCallBack]];
            [[self currentService] setServiceCallBack:^(NSError *error, SproutWebService *service) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SproutServiceCallBack callback = [self serviceCallBack];
                    if ([self currentService]) {
                        [[self queue] removeObject:[self currentService]];
                    }
                    [self setCurrentService:nil];
                    [self setServiceCallBack:nil];
                    if (callback) {
                        callback(error, service);
                    }
                    [self processQueue];
                });
            }];
            [[self currentService] start];
        }
    });
}

@end
