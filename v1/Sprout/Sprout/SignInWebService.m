//
//  SignInWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SignInWebService.h"

@implementation SignInWebService

# pragma mark SignInWebService

+ (SignInWebService*)signInUserWithEmail:(NSString*)email
                            withPassword:(NSString*)password
                            withCallback:(SproutServiceCallBack)callBack
{
    SignInWebService *service = [[SignInWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Login",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email,
                              @"encodedPassword":[service encode64String:password] }];
    [service start];
    return service;
}

+ (SignInWebService*)requestResetPasswordForEmail:(NSString*)email
                                     withCallback:(SproutServiceCallBack)callBack
{
    SignInWebService *service = [[SignInWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/ForgotPassword",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email }];
    [service start];
    return service;
}

+ (SignInWebService*)signUpUserWithName:(NSString*)name
                              withEmail:(NSString*)email
                           withPassword:(NSString*)password
                           withCallback:(SproutServiceCallBack)callBack
{
    SignInWebService *service = [[SignInWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Register",SPROUT_API_URL]];
    [service setParameters:@{ @"userName":name,
                              @"email":email,
                              @"encodedPassword":[service encode64String:password] }];
    [service start];
    return service;
}

+ (SignInWebService*)signOutUserWithEmail:(NSString*)email
                             withCallback:(SproutServiceCallBack)callBack
{
    SignInWebService *service = [[SignInWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/Logout",SPROUT_API_URL]];
    [service setParameters:@{}];
    [service start];
    return service;
}

@end
