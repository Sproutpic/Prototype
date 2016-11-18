//
//  ProjectTableViewCellDelegate.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

@class Project;

@protocol ProjectTableViewCellDelegate <NSObject>

- (void)useCameraToAddNewSproutToProject:(Project*)project;

@optional

- (void)showProjectDetails:(Project*)project;

@end
