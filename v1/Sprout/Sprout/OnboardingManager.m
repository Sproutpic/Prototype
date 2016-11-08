//
//  OnboardingManager.m
//  Sprout
//
//  Created by Jeff Morris on 11/7/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "OnboardingManager.h"
#import "OnboardingViewController.h"
#import "UIUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#define PREF_ONBOARDING_SHOWN @"PREF_ONBOARDING_SHOWN"

static OnboardingManager *shared = nil;

@interface OnboardingManager ()
@property (strong, nonatomic) OnboardingViewController *onboardingVC;
@end

@implementation OnboardingManager

# pragma mark Private

+ (OnboardingManager*)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[OnboardingManager alloc] init];
    });
    return shared;
}

# pragma mark Public

+ (void)showOnboardingOn:(UIViewController*)vc forceShow:(BOOL)force
{
    BOOL alreadyShown = [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ONBOARDING_SHOWN];
    OnboardingManager *om = [OnboardingManager sharedInstance];
    if (vc && (force || !alreadyShown) && ![om onboardingVC]) {
        [om setOnboardingVC:
        [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"onboarding-background"] contents:
         @[
           [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"Welcome",@"Welcome")
                                                        body:NSLocalizedString(@"SproutPic is here to inspire and motivate you!",@"SproutPic is here to inspire and motivate you!")
                                                       image:[UIImage imageNamed:@"logo-white"]
                                                  buttonText:NSLocalizedString(@"Learn More",@"Learn More")
                                                      action:^{
                                                          [[[OnboardingManager sharedInstance] onboardingVC] moveNextPage];
                                                      }],
           [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"Camera Access",@"Camera Access")
                                                        body:NSLocalizedString(@"SproutPic uses your camera to take pictures and show your progress over time.",@"proutPic uses your camera to take pictures and show your progress over time.")
                                                       image:[UIImage imageNamed:@"button-selfie"]
                                                  buttonText:(alreadyShown) ? NSLocalizedString(@"Next",@"Next") : NSLocalizedString(@"Grant Camera Access",@"Grant Camera Access")
                                                      action:^{
                                                          [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                                                              [[[OnboardingManager sharedInstance] onboardingVC] moveNextPage];
                                                          }];
                                                      }],
           [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"Push Notifications",@"Push Notifications")
                                                        body:NSLocalizedString(@"SproutPic uses notifications to remind you when it's time to take another picture.",@"SproutPic uses notifications to remind you when it's time to take another picture.")
                                                       image:[UIImage imageNamed:@"onboarding-notification"]
                                                  buttonText:(alreadyShown) ? NSLocalizedString(@"Next",@"Next") : NSLocalizedString(@"Grant Notification Access",@"Grant Notification Access")
                                                      action:^{
                                                          [[UIApplication sharedApplication] registerUserNotificationSettings:
                                                           [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
                                                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                          [[[OnboardingManager sharedInstance] onboardingVC] moveNextPage];
                                                      }],
           [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"Lets Get Started!",@"Lets Get Started!")
                                                        body:NSLocalizedString(@"You are all ready to go. Are you ready to create a new SproutPic Project?",@"You are all ready to go. Are you ready to create a new SproutPic Project?")
                                                       image:[UIImage imageNamed:@"onboarding-finished"]
                                                  buttonText:(alreadyShown) ? NSLocalizedString(@"Get Started",@"Get Started") :NSLocalizedString(@"Create My First Sprout", @"Create My First Sprout")
                                                      action:^{
                                                          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_ONBOARDING_SHOWN];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                          [[[OnboardingManager sharedInstance] onboardingVC] dismissViewControllerAnimated:YES completion:^{
                                                              [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                                              [[OnboardingManager sharedInstance] setOnboardingVC:nil];
                                                          }];
                                                      }]
           ]]];
        [[om onboardingVC] setShouldFadeTransitions:YES];
        [[om onboardingVC] setSwipingEnabled:NO];
        [[om onboardingVC] setPageControl:nil];
        [vc presentViewController:[om onboardingVC] animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    }
}

@end
