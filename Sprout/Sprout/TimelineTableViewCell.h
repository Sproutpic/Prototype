//
//  TimelineTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTableViewCellDelegate.h"

@class Project;

@interface TimelineTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) Project *project;
@property (weak, nonatomic) id<ProjectTableViewCellDelegate> projectDelegate;
@property (nonatomic) BOOL editState;

@end
