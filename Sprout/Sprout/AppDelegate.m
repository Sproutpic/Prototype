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
#import "AFNetworkActivityLogger.h"
#import "ProjectDetailViewController.h"
#import "AccountWebService.h"
#import "JDMLocalNotification.h"

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

- (void)gotoProjectDetailForNotification:(UILocalNotification *)notification withApplication:(UIApplication *)application
{
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo && [userInfo objectForKey:NOTIFICATION_KEY_PROJECT_UUID]) {
        NSString *uuid = [userInfo objectForKey:NOTIFICATION_KEY_PROJECT_UUID];
        Project *project = [Project findByUUID:uuid withMOC:[[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"Test" andConcurrency:NSMainQueueConcurrencyType]];
        if (project) {
            ProjectDetailViewController *pvc = [[ProjectDetailViewController alloc] init];
            [pvc setProject:project];
            UINavigationController *nvc = nil;
            UIViewController *vc = [[application keyWindow] rootViewController];
            if ([vc isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tvc = (UITabBarController*)vc;
                vc = [tvc selectedViewController];
                if ([vc isKindOfClass:[UINavigationController class]]) {
                    nvc = (UINavigationController*)vc;
                } else {
                    nvc = [vc navigationController];
                }
            }
            if (!nvc) {
                nvc = [vc navigationController];
            }
            
            // If we have an nvc, go to the root and then show the project details...
            if (nvc) {
                [CATransaction begin];
                [nvc popToRootViewControllerAnimated:NO];
                [CATransaction setCompletionBlock:^{
                    [nvc pushViewController:pvc animated:NO];
                }];
                [CATransaction commit];
            }
        }
    }
}

# pragma mark AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class],[Answers class],[Twitter class]]];
    [self configureGlobalTheme];
    //[self createDemoData];
    [self setMainWithControllers];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [application setApplicationIconBadgeNumber:0];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    NSArray *loggers = [[[AFNetworkActivityLogger sharedLogger] loggers] allObjects];
    for (id<AFNetworkActivityLoggerProtocol> logger in loggers) {
        logger.level = AFLoggerLevelDebug;
    }
    
    // To see if the app was open by tapping a local notification
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        [self gotoProjectDetailForNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] withApplication:application];
    }
    
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
    [Project updateAllProjectNotifications];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Only go to the project detail if the app was inactive or in the background
    if ([application applicationState]!=UIApplicationStateActive) {
        [self gotoProjectDetailForNotification:notification withApplication:application];
    }
}

# pragma mark SproutWebServiceAuthDelegate

- (IBAction)textChanged:(id)sender
{
    if (sender && [sender isKindOfClass:[UITextField class]]) {
        UIResponder *responder = (UIResponder*)sender;
        while (![responder isKindOfClass:[UIAlertController class]]) {
            responder = [responder nextResponder];
        }
        UIAlertController *alert = (UIAlertController*)responder;
        UITextField *usernameTxt = [[alert textFields] objectAtIndex:0];
        UITextField *passwordTxt = [[alert textFields] objectAtIndex:1];
        [[[alert actions] objectAtIndex:0] setEnabled:([[usernameTxt text] length]>0 && [[passwordTxt text] length]>0)];
    }
}

- (void)authenticationNeeded:(void (^)(NSError *error))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sign In", @"Sign In")
                                                                   message:NSLocalizedString(@"You need to Sign-In to use SproutPic",
                                                                                             @"You need to Sign-In to use SproutPic")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:NSLocalizedString(@"Username/Email", @"Username/Email")];
        [textField setClearButtonMode:UITextFieldViewModeAlways];
        [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:NSLocalizedString(@"Password", @"Password")];
        [textField setClearButtonMode:UITextFieldViewModeAlways];
        [textField setSecureTextEntry:YES];
        [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sign In", @"Sign In")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                // All looks good, so lets call the web service...
                                                [[AccountWebService signInUserWithEmail:[[[[alert textFields] objectAtIndex:0] text] copy]
                                                                           withPassword:[[[[alert textFields] objectAtIndex:1] text] copy]
                                                                           withCallback:
                                                  ^(NSError *error, SproutWebService *service) {
                                                      if (error) {
                                                          // Failure, so show a message and then call the same authentication peice
                                                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Username/Password", @"Invalid Username/Password")
                                                                                                                         message:NSLocalizedString(@"Enter a valid username and/or password to Sign In",
                                                                                                                                                   @"Enter a valid username and/or password to Sign In")
                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                          [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                                                      [self authenticationNeeded:completion];
                                                                                                  }]];
                                                          [[[self window] rootViewController] presentViewController:alert animated:YES completion:nil];
                                                      } else {
                                                          // We logged in, so not lets finish out this completion block.
                                                          completion(nil);
                                                      }
                                                  }] start];
                                            }]];
    [[[alert actions] objectAtIndex:0] setEnabled:NO];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                completion([NSError errorWithDomain:@"Don't Continue" code:0 userInfo:nil]);
                                            }]];
    [[[self window] rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end
