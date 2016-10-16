//
//  AppDelegate.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DemoData.h"
#import "CommunityViewController.h"
#import "NewProjectViewController.h"
#import "MyProjectsViewController.h"
#import "SettingsViewController.h"
#import "UIUtils.h"

@implementation AppDelegate

# pragma mark Private

- (void)setMainWithControllers
{
    // Create the Tab Controller and all its ViewControllers
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:[[MyProjectsViewController alloc] init]],
                                        [[UINavigationController alloc] initWithRootViewController:[[NewProjectViewController alloc] init]],
                                        [[UINavigationController alloc] initWithRootViewController:[[CommunityViewController alloc] init]]]];
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
    
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor blueColor]];
    [[UIToolbar appearance] setBarTintColor:[UIColor blueColor]];
    
    [[UITabBar appearance] setTintColor:[UIUtils colorNavigationBar]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1]];
    [[UITabBar appearance] setTranslucent:NO];
    
    // Set the status bar color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

# pragma mark AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureGlobalTheme];
    [self createDemoData];
    [self setMainWithControllers];
    return YES;
}

@end
