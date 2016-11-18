//
//  CurrentUser.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CurrentUser.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation CurrentUser
    
# pragma mark Private

+ (void)logUser
{
    //[CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:[CurrentUser emailAddress]];
    [CrashlyticsKit setUserName:[CurrentUser fullName]];
}

# pragma mark CurrentUser

+ (BOOL)isLoggedIn
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY];
    return (user) ? YES : NO;
}

+ (void)setUser:(NSDictionary*)user
{
    if (user==nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_USER_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:CURRENT_USER_USER_KEY];
        [CurrentUser logUser];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)fullName
{
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY] objectForKey:CURRENT_USER_NAME_KEY];
    return (!name) ? @"" : name;
}

+ (NSString*)emailAddress
{
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY] objectForKey:CURRENT_USER_EMAIL_KEY];
    return (!email) ? @"" : email;
}

+ (NSString*)authToken
{
    NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY] objectForKey:CURRENT_USER_ACCESS_TOKEN];
    NSString *type = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY] objectForKey:CURRENT_USER_TOKEN_TYPE];
    return (!token && !type) ? @"" : [NSString stringWithFormat:@"%@ %@",type,token];
}

@end
