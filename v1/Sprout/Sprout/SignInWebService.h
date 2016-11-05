//
//  SignInWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"

@interface SignInWebService : SproutWebService

+ (SignInWebService*)signInUserWithEmail:(NSString*)email
                            withPassword:(NSString*)password
                            withCallback:(SproutServiceCallBack)callBack;

+ (SignInWebService*)requestResetPasswordForEmail:(NSString*)email
                                     withCallback:(SproutServiceCallBack)callBack;

+ (SignInWebService*)signUpUserWithName:(NSString*)name
                              withEmail:(NSString*)email
                           withPassword:(NSString*)password
                           withCallback:(SproutServiceCallBack)callBack;

+ (SignInWebService*)signOutUserWithEmail:(NSString*)email
                           withCallback:(SproutServiceCallBack)callBack;

@end
