//
//  AppDelegate.h
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityViewController.h"
#import "NewProjectViewController.h"
@class NewProjectViewController;
#import "MyProjectsViewController.h"
@class MyProjectsViewController;
#import "SettingsViewController.h"
@class  SettingsViewController;
#import "JASidePanelController.h"
#import "UIUtils.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIUtils *utils;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyProjectsViewController *myProjsController;
@property (strong, nonatomic) NewProjectViewController *projController;
@property (strong, nonatomic) CommunityViewController *commController;
@property (strong, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) UILabel *label,*label1,*label2;
@property (strong, nonatomic) UIImageView *imageView,*imageView1,*imageView2;
@property (strong, nonatomic) UIView *tabBarView;
- (void)resetTab;
@end

