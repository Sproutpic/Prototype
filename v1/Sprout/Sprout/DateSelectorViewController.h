//
//  DateSelectorViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/29/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "BaseViewController.h"

@protocol DateSelectorViewControllerDelegate <NSObject>

- (void)dateChanged:(UIDatePicker*)datePicker withTag:(NSInteger)tag;

@end

@interface DateSelectorViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSInteger tag;
@property (weak, nonatomic) id<DateSelectorViewControllerDelegate> dateDelegate;

@end
