//
//  AppDelegate.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DemoData.h"
#import "MyProjectsViewController.h"
#import "CommunityViewController.h"
#import "SelectNewProjectViewController.h"
#import "UIUtils.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import "DataObjects.h"

@implementation AppDelegate

# pragma mark Private

- (void)setMainWithControllers
{
    // Create the Tab Controller and all its ViewControllers
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:
     @[
       [[UINavigationController alloc] initWithRootViewController:[[MyProjectsViewController alloc] init]],
       [[UINavigationController alloc] initWithRootViewController:[[SelectNewProjectViewController alloc] initWithNibName:@"SelectNewProjectViewController" bundle:nil]],
       [[UINavigationController alloc] initWithRootViewController:[[CommunityViewController alloc] init]],
       ]];
    [tabController setSelectedViewController:[[tabController viewControllers] objectAtIndex:0]];

    // Create the primary window and add it the stack...
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setRootViewController:tabController];
    [[self window] makeKeyAndVisible];
}

- (void)configureGlobalTheme
{    
    [[UINavigationBar appearance] setBarTintColor:[UIUtils colorNavigationBar]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIUtils colorNavigationBar]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, -200)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor blueColor]];
    [[UIToolbar appearance] setBarTintColor:[UIColor blueColor]];
    
    [[UITabBar appearance] setTintColor:[UIUtils colorNavigationBar]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1]];
    [[UITabBar appearance] setTranslucent:NO];
}

# pragma mark AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class],[Answers class],[Twitter class]]];
    [self configureGlobalTheme];
    [self createDemoData];
    [self setMainWithControllers];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [Project updateAllProjectNotifications];
}

@end
