//
//  SproutWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>

// API Docs: http://104.155.191.194/Help

#define DEMO_MODE               YES
#define SPROUT_URL              @"http://104.155.191.194"
#define SPROUT_COMMUNITY_URL    [NSString stringWithFormat:@"%@/Community", SPROUT_URL]
#define SPROUT_API_URL          [NSString stringWithFormat:@"%@/api/Mobile", SPROUT_URL]

@protocol SproutWebServiceDelegate <NSObject>

- (void)completedSuccess:(id)responseObject;
- (void)completedFailure:(NSError*)error;

@end

@interface SproutWebService : NSObject <SproutWebServiceDelegate>

typedef void (^ SproutServiceCallBack)(NSError *error, SproutWebService* service);
@property (strong, nonatomic) SproutServiceCallBack serviceCallBack;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;

- (void)start;

- (NSString*)encode64String:(NSString*)value;

@end
