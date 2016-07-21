//
//  SignUpViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "AccountInformationViewController.h"
@class AccountInformationViewController;
#import "SignInViewController.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate>{
    UIUtils *utils;
    UITextField *fieldName, *fieldEmail, *fieldPassword;
    
}
@property (strong,nonatomic)AccountInformationViewController *accountInfoController;

@end
