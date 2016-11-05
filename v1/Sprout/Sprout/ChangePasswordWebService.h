//
//  ChangePasswordWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"

@interface ChangePasswordWebService : SproutWebService

+ (ChangePasswordWebService*)changePasswordForEmail:(NSString*)email
                                    currentPassword:(NSString*)passwordCurrent
                                        newPassword:(NSString*)passwordNew
                                       withCallback:(SproutServiceCallBack)callBack;

@end
