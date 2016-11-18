//
//  SliderTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sliderTitle;
@property (weak, nonatomic) IBOutlet UILabel *minLbl;
@property (weak, nonatomic) IBOutlet UILabel *maxLbl;
@property (weak, nonatomic) IBOutlet UISlider *slider;

typedef void (^ SliderCallBack)(UISlider *slider, UITableViewCell *cell);
@property (strong, nonatomic) SliderCallBack sliderCallback;

- (IBAction)sliderChanged:(id)sender;

@end
