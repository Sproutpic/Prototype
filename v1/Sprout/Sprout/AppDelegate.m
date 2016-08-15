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
    utils = [[UIUtils alloc] init];
    
    [[UINavigationBar appearance] setBarTintColor:[utils colorNavigationBar]];
    [[UINavigationBar appearance] setTintColor:[utils colorNavigationBar]];
    [[UINavigationBar appearance] setBackgroundColor:[utils colorNavigationBar]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    _myProjsController = [[MyProjectsViewController alloc] init];
    _projController = [[NewProjectViewController alloc] init];
    _commController = [[CommunityViewController alloc] init];
    _commController.projects = [_myProjsController getProjects];
    
    _myProjsController.view.backgroundColor = [UIColor whiteColor];
    _projController.view.backgroundColor = [UIColor whiteColor];
    _commController.view.backgroundColor = [UIColor whiteColor];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:_myProjsController];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_projController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_commController];
    _tabController = [[UITabBarController alloc]init];
    _tabController.viewControllers = @[_nav,nav1,nav2];
    [self setupTabBAr:_tabController];
    JASidePanelController *sidePanel = [[JASidePanelController alloc] init];
    _settingsController = [[SettingsViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    sidePanel.rightPanel = nav3;
    sidePanel.centerPanel = _tabController;
    self.window.rootViewController = sidePanel;
    [self.window makeKeyAndVisible];
}
-(void)setupTabBAr:(UITabBarController *)tabController{
    [tabController.tabBar removeFromSuperview];
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, tabController.view.frame.size.height - 50, tabController.view.frame.size.width, 50)];
    _tabBarView.backgroundColor = [UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _tabBarView.frame.size.width / 3, _tabBarView.frame.size.height)];
    button.tag = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 13, button.frame.size.width, 10)];
    label.text = @"My Projects";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [utils colorNavigationBar];
    label.font = [utils fontRegularForSize:10];
    _label = label;
    [button addSubview:_label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, button.frame.size.width, 21)];
    imageView.image = [UIImage imageNamed:@"projector-green"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
    [button addSubview:_imageView];
    
    [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
    _firstTab = button;
    [_tabBarView addSubview:_firstTab];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(_tabBarView.frame.size.width / 3, 0, _tabBarView.frame.size.width / 3, _tabBarView.frame.size.height)];
    button.tag = 2;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 13, button.frame.size.width, 10)];
    label.text = @"New Project";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1];
    label.font = [utils fontRegularForSize:10];
    _label1 = label;
    [button addSubview:_label1];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, button.frame.size.width, 25)];
    imageView.image = [UIImage imageNamed:@"Plus-grey"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView1 = imageView;
    [button addSubview:_imageView1];
    
    [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(_tabBarView.frame.size.width / 3 * 2, 0, _tabBarView.frame.size.width / 3, _tabBarView.frame.size.height)];
    button.tag = 3;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 13, button.frame.size.width, 10)];
    label.text = @"Community";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1];
    label.font = [utils fontRegularForSize:10];
    _label2 = label;
    [button addSubview:_label2];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, button.frame.size.width, 19)];
    imageView.image = [UIImage imageNamed:@"Team-grey"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView2 = imageView;
    [button addSubview:_imageView2];
    
    [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:button];
    
    [tabController.view addSubview:_tabBarView];
}
- (IBAction)selectTab:(UIButton *)sender{
    [self resetTab];
    for (id sub in sender.subviews) {
        if([sub isKindOfClass:[UILabel class]]){
            ((UILabel *)sub).textColor = ([((UILabel *)sub).textColor isEqual:[utils colorNavigationBar]]) ? [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1] : [utils colorNavigationBar];
        }
    }
    switch (sender.tag) {
        case 1:
            _tabController.selectedIndex = 0;
            _imageView.image = [UIImage imageNamed:@"projector-green"];
            break;
        case 2:
            _tabController.selectedIndex = 1;
            _imageView1.image = [UIImage imageNamed:@"Plus-green"];
            break;
        case 3:
            _tabController.selectedIndex = 2;
            _imageView2.image = [UIImage imageNamed:@"Team-green"];
            break;
        default:
            break;
    }
}
- (void)resetTab{
    _label.textColor = [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1];
    _label1.textColor = [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1];
    _label2.textColor = [UIColor colorWithRed:184.f/255.f green:184.f/255.f blue:184.f/255.f alpha:1];
    
    _imageView.image = [UIImage imageNamed:@"projector-grey"];
    _imageView1.image = [UIImage imageNamed:@"Plus-grey"];
    _imageView2.image = [UIImage imageNamed:@"Team-grey"];
}
@end
