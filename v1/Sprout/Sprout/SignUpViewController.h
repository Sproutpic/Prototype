//
//  SignUpViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInformationViewController.h"
@class AccountInformationViewController;
#import "SignInViewController.h"
#import "WebService.h"
#import "FTPCreateManager.h"

@class WebService;

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *fieldName, *fieldEmail, *fieldPassword;
    WebService *webService;
    UIImageView *checkImage;
    FTPCreateManager *ftpCreateManager;
}

@property (strong,nonatomic)AccountInformationViewController *accountInfoController;

- (void)showAlertWithMessage:(NSString *)str;
- (void)signUpSuccess;
@end
