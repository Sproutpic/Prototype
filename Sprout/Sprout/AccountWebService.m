//
//  AccountWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountWebService.h"
#import "CurrentUser.h"
#import "DataObjects.h"

#define SERVICE_TAG_SIGN_IN             @"SERVICE_TAG_SIGN_IN"
#define SERVICE_TAG_SIGN_UP             @"SERVICE_TAG_SIGN_UP"
#define SERVICE_TAG_RESET_PASSWORD      @"SERVICE_TAG_RESET_PASSWORD"
#define SERVICE_TAG_CHANGE_PASSWORD     @"SERVICE_TAG_CHANGE_PASSWORD"
#define SERVICE_TAG_GET_ACCOUNT         @"SERVICE_TAG_GET_ACCOUNT"
#define SERVICE_TAG_UPDATE_ACCOUNT      @"SERVICE_TAG_UPDATE_ACCOUNT"

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

#define SERVICE_URL_GET_ACCOUNT         [NSString stringWithFormat:@"%@/GetAccount",SPROUT_API_URL]
#define SERVICE_URL_UPDATE_ACCOUNT      [NSString stringWithFormat:@"%@/UpdateAccount",SPROUT_API_URL]
#define PARAM_KEY_ACCOUNT_EMAIL         @"email"
#define PARAM_KEY_ACCOUNT_NAME          @"name"
#define PARAM_KEY_ACCOUNT_GENDER        @"gender"

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
    // Clear the user information
    [CurrentUser setUser:nil];
    // Now delete all the data (that's not synced with the server)
    NSArray * projects = [[CoreDataAccessKit sharedInstance] findObjects:NSStringFromClass([Project class])
                                                            forPredicate:[NSPredicate predicateWithFormat:@"serverId > 0"]
                                                                withSort:nil
                                                                   inMOC:[[CoreDataAccessKit sharedInstance] managedObjectContext]];
    for (Project *project in projects) {
        [project deleteAndSave];
    }
    // Call the callback, if any...
    if (callBack) callBack(nil,nil);
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

+ (AccountWebService*)getAccountInfoWithCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_ACCOUNT];
    [service setParameters:@{ }];
    [service setOauthEnabled:YES];
    [service setServiceTag:SERVICE_TAG_GET_ACCOUNT];
    return service;
}

+ (AccountWebService*)updateAccountInfo:(NSString*)email
                                   name:(NSString*)name
                                 gender:(NSString*)gender
                           withCallback:(SproutServiceCallBack)callBack
{
    AccountWebService *service = [[AccountWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_UPDATE_ACCOUNT];
    [service setParameters:@{ PARAM_KEY_ACCOUNT_EMAIL : email,
                              PARAM_KEY_ACCOUNT_NAME : name,
                              PARAM_KEY_ACCOUNT_GENDER : gender
                              }];
    [service setOauthEnabled:YES];
    [service setServiceTag:SERVICE_TAG_UPDATE_ACCOUNT];
    return service;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    NSLog(@"Response - %@",responseObject);
    
    if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_IN]) {
        NSDictionary *response = (NSDictionary*)responseObject;
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_IN_USERNAME],
                                CURRENT_USER_GENDER_KEY : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_ACCESS_TOKEN : [response objectForKey:CURRENT_USER_ACCESS_TOKEN],
                                CURRENT_USER_TOKEN_TYPE : [response objectForKey:CURRENT_USER_TOKEN_TYPE],
                                CURRENT_USER_EXPIRES_IN : [response objectForKey:CURRENT_USER_EXPIRES_IN]
                                }];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_SIGN_UP]) {
        NSDictionary *response = (NSDictionary*)responseObject;
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_NAME],
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_SIGN_UP_USERNAME],
                                CURRENT_USER_GENDER_KEY : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_ACCESS_TOKEN : [response objectForKey:CURRENT_USER_ACCESS_TOKEN],
                                CURRENT_USER_TOKEN_TYPE : [response objectForKey:CURRENT_USER_TOKEN_TYPE],
                                CURRENT_USER_EXPIRES_IN : [response objectForKey:CURRENT_USER_EXPIRES_IN] }];
        // Now update the account...
        [[AccountWebService updateAccountInfo:[[self parameters] objectForKey:PARAM_KEY_SIGN_UP_USERNAME]
                                         name:[[self parameters] objectForKey:PARAM_KEY_SIGN_UP_NAME]
                                       gender:DEFAULT_DUMMY_PLACE_HOLDER
                                 withCallback:^(NSError *error, SproutWebService *service) {
                                     [super completedSuccess:responseObject];
                                 }] start];
        return;
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_RESET_PASSWORD]) {
        // Nothing to do...
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_CHANGE_PASSWORD]) {
        // Nothing to do...
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_GET_ACCOUNT]) {
        NSDictionary *response = (NSDictionary*)responseObject;
        NSDictionary *currentUser = [CurrentUser getUser];
        NSString *name = [response objectForKey:PARAM_KEY_ACCOUNT_NAME];
        NSString *gender = [response objectForKey:PARAM_KEY_ACCOUNT_GENDER];
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : (![self isNull:name]) ? name : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_EMAIL_KEY : [CurrentUser emailAddress],
                                CURRENT_USER_GENDER_KEY : (![self isNull:gender]) ? gender : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_ACCESS_TOKEN : [currentUser objectForKey:CURRENT_USER_ACCESS_TOKEN],
                                CURRENT_USER_TOKEN_TYPE : [currentUser objectForKey:CURRENT_USER_TOKEN_TYPE],
                                CURRENT_USER_EXPIRES_IN : [currentUser objectForKey:CURRENT_USER_EXPIRES_IN]
                                }];
    } else if ([[self serviceTag] isEqualToString:SERVICE_TAG_UPDATE_ACCOUNT]) {
        NSDictionary *response = (NSDictionary*)responseObject;
        NSDictionary *currentUser = [CurrentUser getUser];
        NSString *name = [response objectForKey:PARAM_KEY_ACCOUNT_NAME];
        NSString *gender = [response objectForKey:PARAM_KEY_ACCOUNT_GENDER];
        [CurrentUser setUser:@{ CURRENT_USER_NAME_KEY : (![self isNull:name]) ? name : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_EMAIL_KEY : [[self parameters] objectForKey:PARAM_KEY_ACCOUNT_EMAIL],
                                CURRENT_USER_GENDER_KEY : (![self isNull:gender]) ? gender : DEFAULT_DUMMY_PLACE_HOLDER,
                                CURRENT_USER_ACCESS_TOKEN : [currentUser objectForKey:CURRENT_USER_ACCESS_TOKEN],
                                CURRENT_USER_TOKEN_TYPE : [currentUser objectForKey:CURRENT_USER_TOKEN_TYPE],
                                CURRENT_USER_EXPIRES_IN : [currentUser objectForKey:CURRENT_USER_EXPIRES_IN]
                                }];
    }
    
    [super completedSuccess:responseObject];
}

- (void)completedFailure:(NSError*)error
{
    NSLog(@"Error - %@",error);

    [super completedFailure:error];
}

@end
