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
#import "MyProjectsViewController.h"
#import "SettingsViewController.h"
#import "JASidePanelController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyProjectsViewController *myProjsController;
@property (strong, nonatomic) NewProjectViewController *projController;
@property (strong, nonatomic) CommunityViewController *commController;
@property (strong, nonatomic) SettingsViewController *settingsController;

@end

