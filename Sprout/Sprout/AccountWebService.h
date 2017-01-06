//
//  AccountWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"

@interface AccountWebService : SproutWebService

+ (AccountWebService*)signInUserWithEmail:(NSString*)email
                             withPassword:(NSString*)password
                             withCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)requestResetPasswordForEmail:(NSString*)email
                                      withCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)signUpUserWithName:(NSString*)name
                               withEmail:(NSString*)email
                            withPassword:(NSString*)password
                            withCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)signOutUserWithEmail:(NSString*)email
                              withCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)changePasswordForEmail:(NSString*)email
                             currentPassword:(NSString*)passwordCurrent
                                 newPassword:(NSString*)passwordNew
                                withCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)getAccountInfoWithCallback:(SproutServiceCallBack)callBack;

+ (AccountWebService*)updateAccountInfo:(NSString*)email
                                   name:(NSString*)name
                                 gender:(NSString*)gender
                           withCallback:(SproutServiceCallBack)callBack;


@end
