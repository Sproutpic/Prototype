//
//  ProjectTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTableViewCellDelegate.h"

@class Project;

@interface ProjectTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) Project *project;
@property (weak, nonatomic) id<ProjectTableViewCellDelegate> projectDelegate;

@end
