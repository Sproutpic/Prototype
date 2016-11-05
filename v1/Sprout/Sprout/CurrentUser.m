//
//  CurrentUser.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

# pragma mark CurrentUser

+ (BOOL)isLoggedIn
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    return (user) ? YES : NO;
}

+ (void)setUser:(NSDictionary*)user
{
    if (user==nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)fullName
{
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"name"];
    return (!name) ? @"" : name;
}

+ (NSString*)emailAddress
{
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"email"];
    return (!email) ? @"" : email;
}

@end
