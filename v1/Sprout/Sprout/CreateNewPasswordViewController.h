//
//  CreateNewPasswordViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 25/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface CreateNewPasswordViewController : UIViewController<UITextFieldDelegate>{
    UIUtils *utils;
    UITextField *fieldNewPass, *fieldRepeatPass;
}

@end
