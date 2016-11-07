//
//  AccountWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountWebService.h"
#import "CurrentUser.h"

#define SERVICE_TAG_SIGN_IN             @"SERVICE_TAG_SIGN_IN"
#define SERVICE_TAG_SIGN_UP             @"SERVICE_TAG_SIGN_UP"
#define SERVICE_TAG_RESET_PASSWORD      @"SERVICE_TAG_RESET_PASSWORD"
#define SERVICE_TAG_SIGN_OUT            @"SERVICE_TAG_SIGN_OUT"
#define SERVICE_TAG_CHANGE_PASSWORD     @"SERVICE_TAG_CHANGE_PASSWORD"

#define SERVICE_URL_SIGN_IN             [NSString stringWithFormat:@"%@/Login",SPROUT_API_URL]
#define PARAM_KEY_SIGN_IN_EMAIL         @"email"
#define PARAM_KEY_SIGN_IN_PASSWORD      @"encodedPassword"

#define SERVICE_URL_SIGN_UP             [NSString stringWithFormat:@"%@/Register",SPROUT_API_URL]
#define PARAM_KEY_SIGN_UP_EMAIL         @"email"
#define PARAM_KEY_SIGN_UP_PASSWORD      @"password"
#define PARAM_KEY_SIGN_UP_CONFIRM       @"confirmPassword"
#define PARAM_KEY_SIGN_UP_USERNAME      @"userName"
#define PARAM_KEY_SIGN_UP_NAME          @"name"

#define SERVICE_URL_FORGOT_PASSWORD     [NSString stringWithFormat:@"%@/ForgotPassword",SPROUT_API_URL]
#define PARAM_KEY_FORGOT_PASSWORD_EMAIL @"email"

#define SERVICE_URL_CHANGE_PASSWORD     [NSString stringWithFormat:@"%@/ChangePassword",SPROUT_API_URL]
#define PARAM_KEY_CHANGE_PASSWORD_OLD   @"oldPassword"
#define PARAM_KEY_CHANGE_PASSWORD_NEW   @"newPassword"
#define PARAM_KEY_CHANGE_PASSWORD_CNFRM @"confirmPassword"

#define SERVICE_URL_LOGOUT              [NSString stringWithFormat:@"%@/Logout",SPROUT_API_URL]

@implementation AccountWebService

# pragma mark AccountWebService

+ (AccountWebService*)signInUserWithEmail:(NSString*)email
                             withPassword:(NSString*)password
                             withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_SIGN_IN];
    [service setParameters:@{ PARAM_KEY_SIGN_IN_EMAIL : email,
                              PARAM_KEY_SIGN_IN_PASSWORD : [service encode64String:password] }];
    [service setServiceTag:SERVICE_TAG_SIGN_IN];
    [service start];
    return service;
}

+ (AccountWebService*)requestResetPasswordForEmail:(NSString*)email
                                      withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_FORGOT_PASSWORD];
    [service setParameters:@{ PARAM_KEY_FORGOT_PASSWORD_EMAIL : email }];
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
    [service setUrl:SERVICE_URL_SIGN_UP];
    [service setParameters:@{
                             PARAM_KEY_SIGN_UP_EMAIL : email,
                             PARAM_KEY_SIGN_UP_PASSWORD : [service encode64String:password],
                             PARAM_KEY_SIGN_UP_CONFIRM : [service encode64String:password],
                             PARAM_KEY_SIGN_UP_USERNAME : email,
                             PARAM_KEY_SIGN_UP_NAME : name
                             }];
    [service setServiceTag:SERVICE_TAG_SIGN_UP];
    [service start];
    return service;
}

+ (AccountWebService*)signOutUserWithEmail:(NSString*)email
                              withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_LOGOUT];
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
    [service setUrl:SERVICE_URL_CHANGE_PASSWORD];
    [service setParameters:@{ @"email" : email,
                              PARAM_KEY_CHANGE_PASSWORD_OLD : [service encode64String:passwordCurrent],
                              PARAM_KEY_CHANGE_PASSWORD_NEW : [service encode64String:passwordNew],
                              PARAM_KEY_CHANGE_PASSWORD_CNFRM : [service encode64String:passwordNew] }];
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
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_IN_EMAIL] }];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_OUT]) {
        [CurrentUser setUser:nil];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_UP]) {
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_NAME],
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_EMAIL] }];
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
