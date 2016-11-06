//
//  AccountWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountWebService.h"
#import "CurrentUser.h"

#define SERVICE_TAG_SIGN_IN         @"SERVICE_TAG_SIGN_IN"
#define SERVICE_TAG_SIGN_UP         @"SERVICE_TAG_SIGN_UP"
#define SERVICE_TAG_RESET_PASSWORD  @"SERVICE_TAG_RESET_PASSWORD"
#define SERVICE_TAG_SIGN_OUT        @"SERVICE_TAG_SIGN_OUT"
#define SERVICE_TAG_CHANGE_PASSWORD @"SERVICE_TAG_CHANGE_PASSWORD"

@implementation AccountWebService

# pragma mark AccountWebService

+ (AccountWebService*)signInUserWithEmail:(NSString*)email
                             withPassword:(NSString*)password
                             withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Login",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email,
                              @"encodedPassword":[service encode64String:password] }];
    [service setServiceTag:SERVICE_TAG_SIGN_IN];
    [service start];
    return service;
}

+ (AccountWebService*)requestResetPasswordForEmail:(NSString*)email
                                      withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/ForgotPassword",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email }];
    [service setServiceTag:SERVICE_TAG_RESET_PASSWORD];
    [service start];
    return service;
}

+ (AccountWebService*)signUpUserWithName:(NSString*)name
                               withEmail:(NSString*)email
                            withPassword:(NSString*)password
                            withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Register",SPROUT_API_URL]];
    [service setParameters:@{ @"userName":name,
                              @"email":email,
                              @"encodedPassword":[service encode64String:password] }];
    [service setServiceTag:SERVICE_TAG_SIGN_UP];
    [service start];
    return service;
}

+ (AccountWebService*)signOutUserWithEmail:(NSString*)email
                              withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Logout",SPROUT_API_URL]];
    [service setParameters:@{}];
    [service setServiceTag:SERVICE_TAG_SIGN_OUT];
    [service start];
    return service;
}

+ (AccountWebService*)changePasswordForEmail:(NSString*)email
                             currentPassword:(NSString*)passwordCurrent
                                 newPassword:(NSString*)passwordNew
                                withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/ChangePassword",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email,
                              @"oldPasswordEncoded":[service encode64String:passwordCurrent],
                              @"newPasswordEncoded":[service encode64String:passwordNew] }];
    [service setServiceTag:SERVICE_TAG_CHANGE_PASSWORD];
    [service start];
    return service;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    NSLog(@"Response - %@",responseObject);
    
    if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_IN]) {
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : @"Demo User",
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:@"userName"] }];
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_OUT]) {
        [CurrentUser setUser:nil];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_UP]) {
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : [[self parameters] objectForKey:@"userName"],
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:@"email"] }];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_RESET_PASSWORD]) {
        // Nothing to do...
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_CHANGE_PASSWORD]) {
        // Nothing to do...
    }
    
    [super completedSuccess:responseObject];
}

- (void)completedFailure:(NSError*)error
{
    NSLog(@"Error - %@",error);

    [super completedFailure:error];
}

@end
