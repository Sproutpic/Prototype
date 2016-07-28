//
//  ChangePasswordViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 28/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>{
    UIUtils *utils;
    UITextField *fieldNewPass, *fieldRepeatPass, *fieldCurrentPass;
}

@end
