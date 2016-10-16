//
//  ProjectTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

@interface ProjectTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) Project *project;

@end
