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
#import "SproutWebService.h"

@interface AppDelegate () <SproutWebServiceAuthDelegate>

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

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
    
    // This hides the back button test.
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
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [application setApplicationIconBadgeNumber:0];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [Project updateAllProjectNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.bgTask = [application beginBackgroundTaskWithName:@"BackgroundTasks" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        [Project updateAllProjectNotifications];

        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [application setApplicationIconBadgeNumber:[application applicationIconBadgeNumber]+1]; // For dev testing...
    [Project updateAllProjectNotifications];
    completionHandler(UIBackgroundFetchResultNewData);
}

# pragma mark SproutWebServiceAuthDelegate

- (void)authenticationNeeded:(void (^)(void))completion
{
    NSLog(@"authenticationNeeded");
    completion();
}

@end
