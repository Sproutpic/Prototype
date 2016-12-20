//
//  OnboardingManager.h
//  Sprout
//
//  Created by Jeff Morris on 11/7/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingManager : NSObject

+ (BOOL)hasOnboardingBeenShown;

+ (void)showOnboardingOn:(UIViewController*)vc forceShow:(BOOL)force;

@end
