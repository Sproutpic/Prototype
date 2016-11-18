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
#define SERVICE_TAG_CHANGE_PASSWORD     @"SERVICE_TAG_CHANGE_PASSWORD"

#define SERVICE_URL_SIGN_IN             [NSString stringWithFormat:@"%@/Token",SPROUT_URL]
#define PARAM_KEY_SIGN_IN_USERNAME      @"username"
#define PARAM_KEY_SIGN_IN_PASSWORD      @"password"
#define PARAM_KEY_SIGN_IN_GRANT_TYPE    @"grant_type"

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

@implementation AccountWebService

# pragma mark AccountWebService

+ (AccountWebService*)signInUserWithEmail:(NSString*)email
                             withPassword:(NSString*)password
                             withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_SIGN_IN];
    [service setParameters:@{ PARAM_KEY_SIGN_IN_USERNAME : email,
                              PARAM_KEY_SIGN_IN_PASSWORD : password,
                              PARAM_KEY_SIGN_IN_GRANT_TYPE : @"password" }];
    [service setServiceTag:SERVICE_TAG_SIGN_IN];
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
    [service setParameters:@{ PARAM_KEY_SIGN_UP_EMAIL : email,
                              PARAM_KEY_SIGN_UP_PASSWORD : password,
                              PARAM_KEY_SIGN_UP_CONFIRM : password,
                              PARAM_KEY_SIGN_UP_USERNAME : email,
                              PARAM_KEY_SIGN_UP_NAME : name
                              }];
    [service setServiceTag:SERVICE_TAG_SIGN_UP];
    return service;
}

+ (AccountWebService*)signOutUserWithEmail:(NSString*)email
                              withCallback:(SproutServiceCallBack)callBack
{
    [CurrentUser setUser:nil];
    callBack(nil,nil);
    return nil;
}

+ (AccountWebService*)changePasswordForEmail:(NSString*)email
                             currentPassword:(NSString*)passwordCurrent
                                 newPassword:(NSString*)passwordNew
                                withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_CHANGE_PASSWORD];
    [service setParameters:@{ PARAM_KEY_CHANGE_PASSWORD_OLD : passwordCurrent,
                              PARAM_KEY_CHANGE_PASSWORD_NEW : passwordNew,
                              PARAM_KEY_CHANGE_PASSWORD_CNFRM : passwordNew }];
    [service setOauthEnabled:YES];
    [service setServiceTag:SERVICE_TAG_CHANGE_PASSWORD];
    return service;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    NSLog(@"Response - %@",responseObject);
    
    if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_IN]) {
        NSDictionary *response = (NSDictionary*)responseObject;
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : @"Unknown",
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_IN_USERNAME],
                                CURRENT_USER_ACCESS_TOKEN : [response objectForKey:CURRENT_USER_ACCESS_TOKEN],
                                CURRENT_USER_TOKEN_TYPE : [response objectForKey:CURRENT_USER_TOKEN_TYPE],
                                CURRENT_USER_EXPIRES_IN : [response objectForKey:CURRENT_USER_EXPIRES_IN]
                                }];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_UP]) {
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_NAME],
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_USERNAME] }];
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
