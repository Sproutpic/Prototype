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
    return ([CurrentUser getUser]) ? YES : NO;
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

+ (NSDictionary*)getUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_USER_KEY];
}

+ (NSString*)fullName
{
    NSString *name = [[CurrentUser getUser] objectForKey:CURRENT_USER_NAME_KEY];
    return (!name) ? @"" : name;
}

+ (NSString*)emailAddress
{
    NSString *email = [[CurrentUser getUser] objectForKey:CURRENT_USER_EMAIL_KEY];
    return (!email) ? @"" : email;
}

+ (NSString*)gender
{
    NSString *email = [[CurrentUser getUser] objectForKey:CURRENT_USER_GENDER_KEY];
    return (!email) ? @"" : email;
}

+ (NSString*)authToken
{
    NSString *token = [[CurrentUser getUser] objectForKey:CURRENT_USER_ACCESS_TOKEN];
    NSString *type = [[CurrentUser getUser] objectForKey:CURRENT_USER_TOKEN_TYPE];
    return (!token && !type) ? @"" : [NSString stringWithFormat:@"%@ %@",type,token];
}

@end
