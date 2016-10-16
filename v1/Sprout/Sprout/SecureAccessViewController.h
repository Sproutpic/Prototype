//
//  SecureAccessViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 19/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnablePasscodeViewController.h"

@interface SecureAccessViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    UIView *switcherView, *pickerTool;
    UISwitch *enableSwitch;
    UIPickerView *autolockSelect;
    NSMutableArray *pickerData;
}

@end
