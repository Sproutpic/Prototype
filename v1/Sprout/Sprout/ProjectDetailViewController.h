//
//  ProjectDetailViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "BaseViewController.h"
#import "ProjectTableViewCellDelegate.h"

@class Project;

@interface ProjectDetailViewController : BaseViewController <ProjectTableViewCellDelegate>

@property (strong,nonatomic) Project *project;

@end
