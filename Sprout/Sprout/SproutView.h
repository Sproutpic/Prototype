//
//  SproutView.h
//  Sprout
//
//  Created by Jeff Morris on 10/26/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

@interface SproutView : UIView

@property (weak, nonatomic) Project *project;

- (IBAction)playButtonTapped:(id)sender;

@end
