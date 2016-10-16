//
//  ChangePasswordViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 28/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@class WebService;

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>{
    UITextField *fieldNewPass, *fieldRepeatPass, *fieldCurrentPass;
    WebService *webService;
}

- (void)showAlertWithMessage:(NSString *)str;

@end
