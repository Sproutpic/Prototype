//
//  SwitchTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchView;

typedef void (^ SwitchCallBack)(UISwitch *switchView);
@property (strong, nonatomic) SwitchCallBack switchCallback;

- (IBAction)switchChanged:(id)sender;

@end
