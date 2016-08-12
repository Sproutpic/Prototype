//
//  ProjectDetailViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "EditProjectDetailsViewController.h"

@interface ProjectDetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    UIUtils *utils;
    UIScrollView *scroller;
    BOOL forCreate;
    UIImageView *sprout, *play;
}
@property (strong,nonatomic)NSDictionary *project;
@property (strong,nonatomic)UICollectionView *timelineCollection;
@property (strong,nonatomic)NSNumber *useFile;
@end
