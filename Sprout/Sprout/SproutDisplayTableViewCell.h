//
//  SproutDisplayTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project, SproutView;

@interface SproutDisplayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SproutView *sproutView;
@property (weak, nonatomic) Project *project;

@end
