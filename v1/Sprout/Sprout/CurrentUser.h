//
//  CurrentUser.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject

+ (BOOL)isLoggedIn;

+ (void)setUser:(NSDictionary*)user;

+ (NSString*)fullName;
+ (NSString*)emailAddress;

@end
