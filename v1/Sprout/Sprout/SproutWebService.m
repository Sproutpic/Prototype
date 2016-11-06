//
//  SproutWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

static NSInteger serviceCallCount = 0;

@implementation SproutWebService

# pragma mark Private

- (void)demoSuccessCallBack
{
    [self showStatusBarSpinner:NO];
    [self completedSuccess:nil];
}

- (void)showStatusBarSpinner:(BOOL)shouldShow
{
    if (shouldShow) {
        serviceCallCount = serviceCallCount + 1;
        if (![[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
    } else {
        serviceCallCount = serviceCallCount - 1;
        if (serviceCallCount<=0) {
            serviceCallCount = 0;
            if ([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
    }
}

# pragma mark SproutWebService

- (void)start
{
    [self showStatusBarSpinner:YES];

    // if DEMO_MODE enabled, just return a successful service call..
    if (DEMO_MODE) {
        [self performSelector:@selector(demoSuccessCallBack) withObject:nil afterDelay:1.0];
        return;
    }
    
    // Actually make the service call...
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [manager POST:[self url]
      parameters:[self parameters]
        progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"Progress - %0.0f",[downloadProgress fractionCompleted]);
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self completedSuccess:responseObject];
             [self showStatusBarSpinner:NO];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self completedFailure:error];
             [self showStatusBarSpinner:NO];
         }];
}

- (NSString*)encode64String:(NSString*)value
{
    if (!value) return @"";
    return [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    if ([self serviceCallBack]) {
        _serviceCallBack(nil, self);
    }
}

- (void)completedFailure:(NSError*)error
{
    if ([self serviceCallBack]) {
        _serviceCallBack(error, self);
    }
}

@end
