//
//  SignInViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "AccountInformationViewController.h"
@class AccountInformationViewController;
#import "CreateNewPasswordViewController.h"
#import "WebService.h"
@class WebService;

@interface SignInViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UIUtils *utils;
    UITextField *fieldEmail, *fieldPassword;
    WebService *webService;
}
@property (strong,nonatomic)AccountInformationViewController *accountInfoController;
- (void)showAlertWithMessage:(NSString *)str;
- (void)signInSuccess;
@end
