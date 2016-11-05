//
//  ButtonTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonTaped:(id)sender;

@end
