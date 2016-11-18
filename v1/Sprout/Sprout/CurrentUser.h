//
//  CurrentUser.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURRENT_USER_USER_KEY       @"CURRENT_USER_USER_KEY"
#define CURRENT_USER_NAME_KEY       @"CURRENT_USER_NAME_KEY"
#define CURRENT_USER_EMAIL_KEY      @"CURRENT_USER_EMAIL_KEY"
#define CURRENT_USER_ACCESS_TOKEN   @"access_token"
#define CURRENT_USER_TOKEN_TYPE     @"token_type"
#define CURRENT_USER_EXPIRES_IN     @"expires_in"

@interface CurrentUser : NSObject

+ (BOOL)isLoggedIn;

+ (void)setUser:(NSDictionary*)user;

+ (NSString*)fullName;
+ (NSString*)emailAddress;
+ (NSString*)authToken;

@end
