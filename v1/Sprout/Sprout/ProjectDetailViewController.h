//
//  ProjectDetailViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

@interface ProjectDetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    UIScrollView *scroller;
    BOOL forCreate;
    UIImageView *sprout, *play;
}

@property (strong,nonatomic) Project *project;
@property (strong,nonatomic) UICollectionView *timelineCollection;
@property (strong,nonatomic) NSNumber *useFile;

@end
