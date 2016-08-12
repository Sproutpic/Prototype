//
//  WebService.h
//  Sprout
//
//  Created by LLDM 0038 on 05/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"
@class SignUpViewController;
#import "SignInViewController.h"
@class SignInViewController;
#import "URLUtils.h"
#import "CreateNewPasswordViewController.h"
@class CreateNewPasswordViewController;
#import "ChangePasswordViewController.h"
@class ChangePasswordViewController;
#import "EditProjectViewController.h"
@class EditProjectViewController;
#import "EditProjectDetailsViewController.h"
@class EditProjectDetailsViewController;

@interface WebService : NSObject{
    NSString *fromRequest;
}
@property (strong,nonatomic)SignUpViewController *signUpController;
@property (strong,nonatomic)SignInViewController *signInController;
@property (strong,nonatomic)CreateNewPasswordViewController *createPassController;
@property (strong,nonatomic)ChangePasswordViewController *changePassController;
@property (strong,nonatomic)EditProjectViewController *editController;
@property (strong,nonatomic)EditProjectDetailsViewController *editDetailController;

- (void)requestSignUpUser:(NSDictionary *)params withTarget:(SignUpViewController *)controller;
- (void)requestSignInUser:(NSDictionary *)params withTarget:(SignInViewController *)controller;
- (void)requestRestorePassword:(NSDictionary *)params withTarget:(SignInViewController *)controller;
- (void)requestChangePassword:(NSDictionary *)params withTarget:(ChangePasswordViewController *)controller;
- (void)requestUploadSprout:(NSDictionary *)params withTarget:(EditProjectViewController *)controller;
- (void)requestUpdateSprout:(NSDictionary *)params withTarget:(EditProjectDetailsViewController *)controller;
@end
