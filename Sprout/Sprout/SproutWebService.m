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
#import "CurrentUser.h"
#import "CoreDataAccessKit.h"

#define OAUTH_AUTHORIZATION_KEY @"Authorization"

static NSInteger serviceCallCount = 0;
static NSDateFormatter *df;

@implementation SproutWebService

# pragma mark Private

- (NSManagedObjectContext*)moc
{
    if (!_moc) {
        _moc = [[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"ProjectWebService"
                                                                          andConcurrency:NSPrivateQueueConcurrencyType];
    }
    return _moc;
}

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

- (NSDictionary *)parameters
{
    if (!_parameters) {
        _parameters = @{};
    }
    return _parameters;
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
    // Check for oauth and add authorization to header parameters
    if ([self oauthEnabled]) {
        NSString *token = [CurrentUser authToken];
        if (token) {
            [[manager requestSerializer] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [[manager requestSerializer] setValue:token forHTTPHeaderField:OAUTH_AUTHORIZATION_KEY];
        }
    }
    [[manager requestSerializer] setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [[manager requestSerializer] setStringEncoding:NSASCIIStringEncoding];
//    [[manager requestSerializer] setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        
//        NSLog(@"Request: %@",request);
//        NSLog(@"Headers: %@",[request allHTTPHeaderFields]);
//        NSLog(@"Params : %@",parameters);
//        NSLog(@"Body   : %@",[request HTTPBody]);
//        NSLog(@"Body   : %@",[request HTTPBody]);
//
//        return nil;
//    }];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
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
    // Check for authentication errors
    if (error) {
        if ([error userInfo] && [[error userInfo] objectForKey:@"NSLocalizedDescription"]) {
            NSString *local = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            if ([local containsString:@"Request failed: unauthorized (401)"]) {
                id<SproutWebServiceAuthDelegate> delegate = (id<SproutWebServiceAuthDelegate>)[[UIApplication sharedApplication] delegate];
                [delegate authenticationNeeded:^(NSError *error) {
                    if (error) {
                        if ([self serviceCallBack]) {
                            [self serviceCallBack](error, self);
                        }
                    } else {
                        [self start];
                    }
                }];
                return;
            }
        }
    }
    
    if ([self serviceCallBack]) {
        [self serviceCallBack](error, self);
    }
}

# pragma mark Sync Helper Methods

- (NSDateFormatter*)dateFormatter
{
    if (df==nil) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]]; // This should be using UTC
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS'Z'"]; // Ex: 2016-11-14T07:59:31.037
    }
    return df;
}

- (BOOL)isNull:(NSObject*)obj
{
    if (obj) {
        if ([obj isKindOfClass:[NSString class]] && [(NSString*)obj isEqualToString:@"<null>"]) {
            return YES;
        } else if ([obj isKindOfClass:[NSNull class]]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (NSString*)stringForKey:(NSString*)key inDict:(NSDictionary*)dictionary
{
    if (key && dictionary) {
        NSObject *obj = [dictionary objectForKey:key];
        if (obj && [obj isKindOfClass:[NSString class]] && ![self isNull:obj]) {
            return (NSString*)obj;
        }
    }
    return @""; // This is the default
}

- (NSNumber*)numberForKey:(NSString*)key inDict:(NSDictionary*)dictionary
{
    if (key && dictionary) {
        NSObject *obj = [dictionary objectForKey:key];
        if (obj && [obj isKindOfClass:[NSNumber class]] && ![self isNull:obj]) {
            return (NSNumber*)obj;
        }
    }
    return @(0); // This is the default
}

- (NSDecimalNumber*)decimalForKey:(NSString*)key inDict:(NSDictionary*)dictionary
{
    if (key && dictionary) {
        NSObject *obj = [dictionary objectForKey:key];
        if (obj && [obj isKindOfClass:[NSDecimalNumber class]] && ![self isNull:obj]) {
            return (NSDecimalNumber*)obj;
        } else if (obj && [obj isKindOfClass:[NSNumber class]] && ![self isNull:obj]) {
            return [NSDecimalNumber decimalNumberWithString:[(NSNumber*)obj stringValue]];
        }
    }
    return [NSDecimalNumber decimalNumberWithString:@"0.0"]; // This is the default
}

- (NSNumber*)boolForKey:(NSString*)key inDict:(NSDictionary*)dictionary
{
    if (key && dictionary) {
        NSObject *obj = [dictionary objectForKey:key];
        if (obj && ![self isNull:obj]) {
            if ([obj isKindOfClass:[NSNumber class]]) {
                return @([(NSNumber*)obj boolValue]);
            } else if ([obj isKindOfClass:[NSString class]]) {
                NSString *str = (NSString*)obj;
                if ([str caseInsensitiveCompare:@"true"]==NSOrderedSame
                    || [str caseInsensitiveCompare:@"yes"]==NSOrderedSame
                    || [str caseInsensitiveCompare:@"1"]==NSOrderedSame) {
                    return @(YES);
                }
            }
        }
    }
    return @(NO); // This is the default
}

- (NSDate*)dateForKey:(NSString*)key inDict:(NSDictionary*)dictionary
{
    if (key && dictionary) {
        NSObject *obj = [dictionary objectForKey:key];
        if (obj && ![self isNull:obj]) {
            if ([obj isKindOfClass:[NSString class]]) {
                return [[self dateFormatter] dateFromString:(NSString*)obj];
            }
        }
    }
    return nil; // This is the default
}

@end
