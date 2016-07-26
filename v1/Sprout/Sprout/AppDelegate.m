//
//  AppDelegate.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setMainWithControllers];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)setMainWithControllers{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _myProjsController = [[MyProjectsViewController alloc] init];
    _projController = [[NewProjectViewController alloc] init];
    _commController = [[CommunityViewController alloc] init];
    
    _myProjsController.view.backgroundColor = [UIColor whiteColor];
    _projController.view.backgroundColor = [UIColor blueColor];
    _commController.view.backgroundColor = [UIColor redColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_myProjsController];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_projController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_commController];
    _nav = nav;
    UITabBarController *tabController = [[UITabBarController alloc]init];
    //tabController.viewControllers = @[_myProjsController,_projController,_commController];
    tabController.viewControllers = @[_nav,nav1,nav2];
    
    JASidePanelController *sidePanel = [[JASidePanelController alloc] init];
    _settingsController = [[SettingsViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    sidePanel.rightPanel = nav3;
    sidePanel.centerPanel = tabController;
    
    self.window.rootViewController = sidePanel;
    [self.window makeKeyAndVisible];
    /*[self referenceControllersToDelegate:mpc newProjController:npc commController:cvc];
    
    [self setControllersBackGround:[UIColor whiteColor]];
    
    [self setTabControllerWithControllers];
    
    [self.window makeKeyAndVisible];*/
}
-(void)setControllersBackGround:(UIColor *)color{
    
    _myProjsController.view.backgroundColor = color;
    _projController.view.backgroundColor = [UIColor blueColor];
    _commController.view.backgroundColor = [UIColor redColor];
    
}
- (void)referenceControllersToDelegate:(MyProjectsViewController *)mpc newProjController:(NewProjectViewController *)npc commController:(CommunityViewController *)cvc{
    
    _myProjsController = mpc;
    _projController = npc;
    _commController = cvc;
    
}
- (void)setTabControllerWithControllers{
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_myProjsController];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_projController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_commController];
    
    UITabBarController *tabController = [[UITabBarController alloc]init];
    //tabController.viewControllers = @[_myProjsController,_projController,_commController];
    tabController.viewControllers = @[nav,nav1,nav2];
    
    [self setPanelWithTab:tabController];
}
- (void)setPanelWithTab:(UITabBarController *)tab{

    JASidePanelController *sidePanel = [[JASidePanelController alloc] init];
    _settingsController = [[SettingsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    sidePanel.rightPanel = nav;
    sidePanel.centerPanel = tab;
    
    [self setWindowRootController:sidePanel];
    
}
- (void)setWindowRootController:(JASidePanelController *)sidePanel{
    self.window.rootViewController = sidePanel;
}
@end
