//
//  CommunityViewController.h
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


@interface CommunityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UIUtils *utils;
    UIScrollView *projectScroller;
    NSDictionary *currentDictionary;
    UILabel *fSprout, *fFeatured, *fTopViewed, *fLongest;
    UIView *underlineView;
    UIView *searchView, *sillhou, *noResultView;
}
@property (strong,nonatomic)UITableView *table;
@property (strong,nonatomic)NSMutableArray* projects;
@end
