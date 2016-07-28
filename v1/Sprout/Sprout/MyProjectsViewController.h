//
//  MyProjectsViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface MyProjectsViewController : UIViewController{
    UIUtils *utils;
    UIScrollView *projectScroller;
    NSMutableArray *projects;
    NSDictionary *currentDictionary;
}

@end
