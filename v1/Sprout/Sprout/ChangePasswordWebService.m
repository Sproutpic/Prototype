//
//  ChangePasswordWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ChangePasswordWebService.h"

@implementation ChangePasswordWebService

# pragma mark ChangePasswordWebService

+ (ChangePasswordWebService*)changePasswordForEmail:(NSString*)email
                                    currentPassword:(NSString*)passwordCurrent
                                        newPassword:(NSString*)passwordNew
                                       withCallback:(SproutServiceCallBack)callBack
{
    ChangePasswordWebService *service = [[ChangePasswordWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/ChangePassword",SPROUT_API_URL]];
    [service setParameters:@{ @"email":email,
                              @"oldPasswordEncoded":[service encode64String:passwordCurrent],
                              @"newPasswordEncoded":[service encode64String:passwordNew] }];
    [service start];
    return service;
}

@end
